import 'package:flutter_test/flutter_test.dart';
import 'package:oscillolab/core/measurement/instrument_model.dart';
import 'package:oscillolab/core/measurement/instrument_range.dart';
import 'package:oscillolab/core/measurement/noise_generator.dart';
import 'package:oscillolab/core/measurement/units.dart';

void main() {
  group('InstrumentModel', () {
    test('cobertura de incertidumbre >= 95% para instrumento calibrado', () {
      const InstrumentRange rango = InstrumentRange(
        etiqueta: '20 V',
        magnitud: Magnitud.voltajeDc,
        valorMaximo: 20,
        ruidoSigma: 0.008,
        resolucionDecimales: 2,
      );
      final InstrumentModel dmm = InstrumentModel(
        nombre: 'Multimetro-DCV-20V',
        rango: rango,
        generador: NoiseGenerator(seed: 42),
      );

      const double valorReal = 12.34;
      const int n = 5000;
      int dentro = 0;
      for (int i = 0; i < n; i++) {
        final ResultadoMedicion r = dmm.medir(valorReal);
        expect(r.enRango, isTrue);
        if ((r.valor - valorReal).abs() <= r.incertidumbre) dentro++;
      }
      final double cobertura = dentro / n;
      expect(cobertura, greaterThanOrEqualTo(0.95));
    });

    test('sobrecarga (OL) cuando el valor supera el rango', () {
      const InstrumentRange rango = InstrumentRange(
        etiqueta: '20 V',
        magnitud: Magnitud.voltajeDc,
        valorMaximo: 20,
        ruidoSigma: 0.008,
        resolucionDecimales: 2,
      );
      final InstrumentModel dmm = InstrumentModel(nombre: 'DMM', rango: rango);
      final ResultadoMedicion r = dmm.medir(25.0);
      expect(r.enRango, isFalse);
    });

    test('ganancia y offset desplazan la lectura de forma predecible', () {
      const InstrumentRange rango = InstrumentRange(
        etiqueta: '20 V',
        magnitud: Magnitud.voltajeDc,
        valorMaximo: 20,
        ruidoSigma:
            0.0001, // ruido despreciable para aislar el efecto sistematico
        resolucionDecimales: 4,
      );
      final InstrumentModel descalibrado = InstrumentModel(
        nombre: 'DMM-descalibrado',
        rango: rango,
        ganancia: 1.05,
        offset: 0.15,
        generador: NoiseGenerator(seed: 1),
      );
      final ResultadoMedicion r = descalibrado.medir(10.0);
      // Esperado: 10*1.05 + 0.15 = 10.65, con tolerancia por el ruido residual.
      expect(r.valor, closeTo(10.65, 0.01));
    });
  });
}
