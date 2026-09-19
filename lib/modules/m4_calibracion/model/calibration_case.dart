import '../../../core/measurement/instrument_model.dart';
import '../../../core/measurement/instrument_range.dart';
import '../../../core/measurement/units.dart';

/// Caso de calibracion: dos patrones de referencia CONOCIDOS (visibles
/// para el estudiante, como en un laboratorio real donde el patron es
/// trazable) y un instrumento cuya ganancia/offset reales estan ocultos:
/// el estudiante debe estimarlos midiendo los patrones, no leyendolos.
class CasoCalibracion {
  const CasoCalibracion({
    required this.id,
    required this.descripcion,
    required this.patronBajo,
    required this.patronAlto,
    required this.rango,
    this.gananciaOculta = 1.0,
    this.offsetOculto = 0.0,
  });

  final String id;
  final String descripcion;
  final double patronBajo;
  final double patronAlto;
  final InstrumentRange rango;
  final double gananciaOculta;
  final double offsetOculto;

  InstrumentModel construirInstrumento() {
    return InstrumentModel(
      nombre: 'Instrumento en calibracion',
      rango: rango,
      ganancia: gananciaOculta,
      offset: offsetOculto,
    );
  }
}

const List<CasoCalibracion> casosCalibracion = [
  CasoCalibracion(
    id: 'multimetro_revision_anual',
    descripcion:
        'Multimetro de planta en su revision periodica anual, contra patron de voltaje trazable.',
    patronBajo: 2.0,
    patronAlto: 18.0,
    rango: InstrumentRange(
        etiqueta: '20 V',
        magnitud: Magnitud.voltajeDc,
        valorMaximo: 20,
        ruidoSigma: 0.008,
        resolucionDecimales: 2),
    gananciaOculta: 1.05,
    offsetOculto: 0.15,
  ),
  CasoCalibracion(
    id: 'sensor_temperatura_nuevo',
    descripcion:
        'Sensor de temperatura recien instalado, verificacion inicial contra bano termostatico patron.',
    patronBajo: 20.0,
    patronAlto: 90.0,
    rango: InstrumentRange(
        etiqueta: '150 °C',
        magnitud: Magnitud.temperatura,
        valorMaximo: 150,
        ruidoSigma: 0.3,
        resolucionDecimales: 1),
    gananciaOculta: 1.0,
    offsetOculto: 0.02,
  ),
  CasoCalibracion(
    id: 'pinza_amperometrica_sospechosa',
    descripcion:
        'Pinza amperometrica que dio lecturas inconsistentes en campo; se revisa contra fuente de corriente patron.',
    patronBajo: 1.0,
    patronAlto: 15.0,
    rango: InstrumentRange(
        etiqueta: '20 A',
        magnitud: Magnitud.corrienteDc,
        valorMaximo: 20,
        ruidoSigma: 0.02,
        resolucionDecimales: 2),
    gananciaOculta: 0.90,
    offsetOculto: -0.05,
  ),
];
