import '../../../core/measurement/instrument_model.dart';
import '../../../core/measurement/instrument_range.dart';
import '../../../core/measurement/units.dart';

/// Caso del Módulo 3: un patrón de referencia real (oculto) y un
/// instrumento con cierto comportamiento (bien calibrado + ruidoso, o
/// descalibrado). El estudiante NO ve gananciaOffset ni el patrón: solo
/// ve las lecturas que el instrumento reporta, igual que en un
/// laboratorio real.
class CasoError {
  const CasoError({
    required this.id,
    required this.descripcion,
    required this.patronReferencia,
    required this.rango,
    this.ganancia = 1.0,
    this.offset = 0.0,
  });

  final String id;
  final String descripcion;
  final double patronReferencia;
  final InstrumentRange rango;
  final double ganancia;
  final double offset;

  InstrumentModel construirInstrumento() {
    return InstrumentModel(
      nombre: 'Instrumento bajo prueba',
      rango: rango,
      ganancia: ganancia,
      offset: offset,
    );
  }
}

const List<CasoError> casosError = [
  CasoError(
    id: 'ruido_normal',
    descripcion:
        'Multímetro bien calibrado midiendo una fuente estable de referencia.',
    patronReferencia: 10.0,
    rango: InstrumentRange(
        etiqueta: '20 V',
        magnitud: Magnitud.voltajeDc,
        valorMaximo: 20,
        ruidoSigma: 0.05,
        resolucionDecimales: 2),
  ),
  CasoError(
    id: 'offset_descalibrado',
    descripcion:
        'Multímetro con sospecha de descalibración midiendo la misma fuente de referencia.',
    patronReferencia: 10.0,
    rango: InstrumentRange(
        etiqueta: '20 V',
        magnitud: Magnitud.voltajeDc,
        valorMaximo: 20,
        ruidoSigma: 0.01,
        resolucionDecimales: 2),
    ganancia: 1.0,
    offset: 0.6,
  ),
  CasoError(
    id: 'ganancia_descalibrada',
    descripcion:
        'Pinza amperométrica con sospecha de error de ganancia, midiendo una corriente patrón.',
    patronReferencia: 5.0,
    rango: InstrumentRange(
        etiqueta: '20 A',
        magnitud: Magnitud.corrienteDc,
        valorMaximo: 20,
        ruidoSigma: 0.02,
        resolucionDecimales: 2),
    ganancia: 1.12,
    offset: 0.0,
  ),
  CasoError(
    id: 'ruido_alto',
    descripcion:
        'Sensor de temperatura en ambiente con mucha interferencia electromagnética.',
    patronReferencia: 75.0,
    rango: InstrumentRange(
        etiqueta: '150 °C',
        magnitud: Magnitud.temperatura,
        valorMaximo: 150,
        ruidoSigma: 1.8,
        resolucionDecimales: 1),
  ),
];
