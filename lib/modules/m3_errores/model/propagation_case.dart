import '../../../core/measurement/instrument_range.dart';
import '../../../core/measurement/units.dart';

/// Caso del ejercicio de propagacion de incertidumbre: se mide voltaje y
/// corriente de forma independiente y se pide calcular la potencia
/// P = V*I junto con su incertidumbre combinada.
class CasoPropagacion {
  const CasoPropagacion({
    required this.id,
    required this.descripcion,
    required this.voltajeReal,
    required this.corrienteReal,
    required this.rangoVoltaje,
    required this.rangoCorriente,
  });

  final String id;
  final String descripcion;
  final double voltajeReal;
  final double corrienteReal;
  final InstrumentRange rangoVoltaje;
  final InstrumentRange rangoCorriente;
}

const List<CasoPropagacion> casosPropagacion = [
  CasoPropagacion(
    id: 'potencia_resistencia_calefactora',
    descripcion: 'Calcula la potencia disipada por una resistencia calefactora en un horno de laboratorio.',
    voltajeReal: 24.0,
    corrienteReal: 2.5,
    rangoVoltaje: InstrumentRange(etiqueta: '200 V', magnitud: Magnitud.voltajeDc, valorMaximo: 200, ruidoSigma: 0.06, resolucionDecimales: 2),
    rangoCorriente: InstrumentRange(etiqueta: '20 A', magnitud: Magnitud.corrienteDc, valorMaximo: 20, ruidoSigma: 0.02, resolucionDecimales: 2),
  ),
  CasoPropagacion(
    id: 'potencia_motor_dc',
    descripcion: 'Calcula la potencia electrica consumida por un motor DC en su punto de operacion nominal.',
    voltajeReal: 12.0,
    corrienteReal: 1.8,
    rangoVoltaje: InstrumentRange(etiqueta: '20 V', magnitud: Magnitud.voltajeDc, valorMaximo: 20, ruidoSigma: 0.008, resolucionDecimales: 2),
    rangoCorriente: InstrumentRange(etiqueta: '2 A', magnitud: Magnitud.corrienteDc, valorMaximo: 2, ruidoSigma: 0.0015, resolucionDecimales: 3),
  ),
];
