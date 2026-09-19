import '../../../core/measurement/instrument_range.dart';
import '../../../core/measurement/units.dart';

/// Escenario de medición con multímetro: una magnitud real OCULTA al
/// estudiante y un conjunto de rangos entre los que debe elegir.
class EscenarioMultimetro {
  const EscenarioMultimetro({
    required this.id,
    required this.descripcion,
    required this.valorReal,
    required this.rangos,
  });

  final String id;
  final String descripcion;
  final double valorReal; // Oculto: solo el motor de medición lo usa.
  final List<InstrumentRange> rangos;
}

const List<EscenarioMultimetro> escenariosMultimetro = [
  EscenarioMultimetro(
    id: 'fuente_12v',
    descripcion: 'Fuente de alimentación DC de un PLC industrial.',
    valorReal: 12.34,
    rangos: [
      InstrumentRange(
          etiqueta: '2 V',
          magnitud: Magnitud.voltajeDc,
          valorMaximo: 2,
          ruidoSigma: 0.001,
          resolucionDecimales: 3),
      InstrumentRange(
          etiqueta: '20 V',
          magnitud: Magnitud.voltajeDc,
          valorMaximo: 20,
          ruidoSigma: 0.008,
          resolucionDecimales: 2),
      InstrumentRange(
          etiqueta: '200 V',
          magnitud: Magnitud.voltajeDc,
          valorMaximo: 200,
          ruidoSigma: 0.08,
          resolucionDecimales: 1),
    ],
  ),
  EscenarioMultimetro(
    id: 'bateria_debil',
    descripcion: 'Batería de respaldo de 9V, posiblemente descargada.',
    valorReal: 7.62,
    rangos: [
      InstrumentRange(
          etiqueta: '2 V',
          magnitud: Magnitud.voltajeDc,
          valorMaximo: 2,
          ruidoSigma: 0.001,
          resolucionDecimales: 3),
      InstrumentRange(
          etiqueta: '20 V',
          magnitud: Magnitud.voltajeDc,
          valorMaximo: 20,
          ruidoSigma: 0.008,
          resolucionDecimales: 2),
      InstrumentRange(
          etiqueta: '200 V',
          magnitud: Magnitud.voltajeDc,
          valorMaximo: 200,
          ruidoSigma: 0.08,
          resolucionDecimales: 1),
    ],
  ),
  EscenarioMultimetro(
    id: 'resistor_pullup',
    descripcion: 'Resistor pull-up de una entrada digital, fuera de circuito.',
    valorReal: 4700,
    rangos: [
      InstrumentRange(
          etiqueta: '2 kΩ',
          magnitud: Magnitud.resistencia,
          valorMaximo: 2000,
          ruidoSigma: 0.9,
          resolucionDecimales: 1),
      InstrumentRange(
          etiqueta: '20 kΩ',
          magnitud: Magnitud.resistencia,
          valorMaximo: 20000,
          ruidoSigma: 9,
          resolucionDecimales: 0),
      InstrumentRange(
          etiqueta: '200 kΩ',
          magnitud: Magnitud.resistencia,
          valorMaximo: 200000,
          ruidoSigma: 90,
          resolucionDecimales: -1),
    ],
  ),
  EscenarioMultimetro(
    id: 'motor_dc_corriente',
    descripcion:
        'Corriente de arranque de un motor DC pequeño en un banco de pruebas.',
    valorReal: 0.845,
    rangos: [
      InstrumentRange(
          etiqueta: '2 A',
          magnitud: Magnitud.corrienteDc,
          valorMaximo: 2,
          ruidoSigma: 0.0015,
          resolucionDecimales: 3),
      InstrumentRange(
          etiqueta: '20 A',
          magnitud: Magnitud.corrienteDc,
          valorMaximo: 20,
          ruidoSigma: 0.015,
          resolucionDecimales: 2),
    ],
  ),
];

/// Escenario de medición con osciloscopio: una señal periódica real OCULTA
/// (amplitud pico-pico y frecuencia) que el estudiante debe medir usando
/// cursores sobre la forma de onda mostrada.
class EscenarioOsciloscopio {
  const EscenarioOsciloscopio({
    required this.id,
    required this.descripcion,
    required this.amplitudPicoPicoReal,
    required this.frecuenciaHzReal,
    required this.formaOnda,
    required this.rangoVoltaje,
    required this.rangoFrecuencia,
  });

  final String id;
  final String descripcion;
  final double amplitudPicoPicoReal;
  final double frecuenciaHzReal;
  final String formaOnda; // 'seno' | 'cuadrada'
  final InstrumentRange rangoVoltaje;
  final InstrumentRange rangoFrecuencia;
}

const List<EscenarioOsciloscopio> escenariosOsciloscopio = [
  EscenarioOsciloscopio(
    id: 'pwm_motor',
    descripcion: 'Señal PWM que controla la velocidad de un motor DC.',
    amplitudPicoPicoReal: 5.0,
    frecuenciaHzReal: 1000,
    formaOnda: 'cuadrada',
    rangoVoltaje: InstrumentRange(
        etiqueta: '10 Vpp',
        magnitud: Magnitud.amplitudPicoPico,
        valorMaximo: 10,
        ruidoSigma: 0.03,
        resolucionDecimales: 2),
    rangoFrecuencia: InstrumentRange(
        etiqueta: '10 kHz',
        magnitud: Magnitud.frecuencia,
        valorMaximo: 10000,
        ruidoSigma: 2,
        resolucionDecimales: 0),
  ),
  EscenarioOsciloscopio(
    id: 'senal_sensor',
    descripcion: 'Salida analógica senoidal de un sensor de vibración.',
    amplitudPicoPicoReal: 2.4,
    frecuenciaHzReal: 60,
    formaOnda: 'seno',
    rangoVoltaje: InstrumentRange(
        etiqueta: '5 Vpp',
        magnitud: Magnitud.amplitudPicoPico,
        valorMaximo: 5,
        ruidoSigma: 0.02,
        resolucionDecimales: 2),
    rangoFrecuencia: InstrumentRange(
        etiqueta: '200 Hz',
        magnitud: Magnitud.frecuencia,
        valorMaximo: 200,
        ruidoSigma: 0.5,
        resolucionDecimales: 1),
  ),
  EscenarioOsciloscopio(
    id: 'ripple_fuente',
    descripcion: 'Rizado (ripple) superpuesto en una fuente DC de conmutación.',
    amplitudPicoPicoReal: 0.35,
    frecuenciaHzReal: 50000,
    formaOnda: 'seno',
    rangoVoltaje: InstrumentRange(
        etiqueta: '1 Vpp',
        magnitud: Magnitud.amplitudPicoPico,
        valorMaximo: 1,
        ruidoSigma: 0.006,
        resolucionDecimales: 3),
    rangoFrecuencia: InstrumentRange(
        etiqueta: '100 kHz',
        magnitud: Magnitud.frecuencia,
        valorMaximo: 100000,
        ruidoSigma: 300,
        resolucionDecimales: -2),
  ),
];
