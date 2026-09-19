"""
OscilloLab - Modelo de medicion calibrado (prototipo Python)
=============================================================

Este script valida ESTADISTICAMENTE el modelo de error antes de portarlo a Dart.
No es parte de la app; es la prueba de calibracion del motor de medicion.

Modelo de instrumento:
    lectura_display = round_to_resolution( valor_real * ganancia + offset + ruido )

- ganancia (gain): error sistematico multiplicativo. gain=1.0 => sin error de ganancia.
- offset: error sistematico aditivo (en unidades de la magnitud medida).
- ruido: gaussiano, sigma proporcional al rango seleccionado (ruido de cuantizacion + electronico).
- resolucion: numero de decimales que el instrumento puede mostrar en ese rango.

Un instrumento "calibrado de fabrica" tiene gain=1.0, offset=0.0 (dentro de tolerancia).
Un instrumento "descalibrado" (para el modulo de Calibracion) tiene gain/offset desviados,
y el estudiante debe medir un patron de referencia conocido para hallarlos y corregirlos.

Verificamos dos propiedades que el motor de Dart debe preservar exactamente:
1. Cobertura de incertidumbre: para un instrumento calibrado con incertidumbre declarada U,
   ~95% de las lecturas deben caer dentro de valor_real +/- U (k=2 sigma).
2. Deteccion de descalibracion: con N mediciones de un patron conocido, el error estimado
   (gain, offset) debe converger al valor real inyectado, dentro de tolerancia razonable.
"""

import random
import math
import json

random.seed(42)


def gaussian_noise(sigma):
    return random.gauss(0.0, sigma)


def round_to_resolution(value, decimals):
    factor = 10 ** decimals
    return round(value * factor) / factor


class Instrument:
    def __init__(self, name, gain, offset, noise_sigma, resolution_decimals, range_max):
        self.name = name
        self.gain = gain
        self.offset = offset
        self.noise_sigma = noise_sigma
        self.resolution_decimals = resolution_decimals
        self.range_max = range_max

    def measure(self, true_value):
        if abs(true_value) > self.range_max:
            return None  # overload / "OL"
        raw = true_value * self.gain + self.offset + gaussian_noise(self.noise_sigma)
        return round_to_resolution(raw, self.resolution_decimals)

    def declared_uncertainty(self):
        # U = k*sigma + medio digito de resolucion (regla de instrumentacion estandar)
        half_digit = 0.5 * (10 ** (-self.resolution_decimals))
        return 2 * self.noise_sigma + half_digit


def test_coverage(instrument, true_value, n=20000):
    # La incertidumbre declarada U = 2*sigma + medio digito es DELIBERADAMENTE
    # conservadora (practica estandar de instrumentacion: garantizar >=95% de
    # cobertura, no acertar 95.45% exacto). Por eso el criterio de aceptacion
    # es "cobertura >= 95%", no una banda estrecha alrededor de 95%.
    inside = 0
    U = instrument.declared_uncertainty()
    for _ in range(n):
        reading = instrument.measure(true_value)
        if reading is None:
            continue
        if abs(reading - true_value) <= U:
            inside += 1
    coverage = inside / n
    return coverage


def test_calibration_recovery(true_gain, true_offset, noise_sigma, resolution, n=500, ref_value=10.0):
    instrument = Instrument("patron_test", true_gain, true_offset, noise_sigma, resolution, 1000)
    readings = [instrument.measure(ref_value) for _ in range(n)]
    mean_reading = sum(readings) / len(readings)
    # Con un solo punto de referencia solo se puede resolver el error combinado
    # (gain*ref + offset). El modulo de calibracion de la app usa DOS patrones
    # (ref_low y ref_high) para resolver gain y offset por separado (regresion lineal).
    return mean_reading


def test_two_point_calibration(true_gain, true_offset, noise_sigma, resolution, n=300):
    instrument = Instrument("dos_puntos", true_gain, true_offset, noise_sigma, resolution, 1000)
    ref_low, ref_high = 2.0, 18.0
    readings_low = [instrument.measure(ref_low) for _ in range(n)]
    readings_high = [instrument.measure(ref_high) for _ in range(n)]
    mean_low = sum(readings_low) / n
    mean_high = sum(readings_high) / n
    # y = gain*x + offset  =>  resolver sistema 2x2
    est_gain = (mean_high - mean_low) / (ref_high - ref_low)
    est_offset = mean_low - est_gain * ref_low
    return est_gain, est_offset


def run_all():
    results = {}

    # --- 1. Cobertura de incertidumbre: multimetro DC voltaje, rango 20V ---
    dmm_v = Instrument("Multimetro-DCV-20V", gain=1.0, offset=0.0,
                        noise_sigma=0.008, resolution_decimals=2, range_max=20.0)
    coverage = test_coverage(dmm_v, true_value=12.34, n=20000)
    results["coverage_multimetro_dcv"] = coverage
    assert coverage >= 0.95, f"Cobertura insuficiente: {coverage}"

    # --- 2. Cobertura para resistencia, rango 2k ohm ---
    dmm_r = Instrument("Multimetro-OHM-2k", gain=1.0, offset=0.0,
                        noise_sigma=0.9, resolution_decimals=1, range_max=2000.0)
    coverage_r = test_coverage(dmm_r, true_value=470.0, n=20000)
    results["coverage_multimetro_ohm"] = coverage_r
    assert coverage_r >= 0.95, f"Cobertura insuficiente: {coverage_r}"

    # --- 3. Deteccion de descalibracion con dos puntos de referencia ---
    injected_gain = 1.05      # +5% de ganancia (tipico drift de calibracion)
    injected_offset = 0.15    # +0.15 V de offset
    est_gain, est_offset = test_two_point_calibration(
        injected_gain, injected_offset, noise_sigma=0.008, resolution=2, n=400)
    results["injected_gain"] = injected_gain
    results["estimated_gain"] = est_gain
    results["injected_offset"] = injected_offset
    results["estimated_offset"] = est_offset
    assert abs(est_gain - injected_gain) < 0.01, "Estimacion de ganancia fuera de tolerancia"
    assert abs(est_offset - injected_offset) < 0.02, "Estimacion de offset fuera de tolerancia"

    # --- 4. Overload: fuera de rango debe devolver None (OL en pantalla) ---
    dmm_ol = Instrument("Multimetro-DCV-20V", gain=1.0, offset=0.0,
                         noise_sigma=0.008, resolution_decimals=2, range_max=20.0)
    results["overload_ok"] = dmm_ol.measure(25.0) is None
    assert results["overload_ok"] is True

    # --- 5. Osciloscopio: medicion de amplitud pico-pico de una senal senoidal ---
    # Vpp_real = 2*Vp ; el osciloscopio mide con su propio ruido + resolucion de pantalla (grid)
    scope = Instrument("Osciloscopio-Vpp", gain=1.0, offset=0.0,
                        noise_sigma=0.05, resolution_decimals=2, range_max=40.0)
    true_vpp = 6.0
    coverage_scope = test_coverage(scope, true_value=true_vpp, n=20000)
    results["coverage_osciloscopio_vpp"] = coverage_scope
    assert coverage_scope >= 0.95

    return results


if __name__ == "__main__":
    out = run_all()
    print(json.dumps(out, indent=2))
    print("\nTODAS LAS PRUEBAS DE CALIBRACION PASARON.")
