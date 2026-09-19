import 'package:flutter_test/flutter_test.dart';
import 'package:oscillolab/core/assistant/assistant_engine.dart';
import 'package:oscillolab/core/assistant/assistant_message.dart';
import 'package:oscillolab/core/measurement/calibration_engine.dart';
import 'package:oscillolab/core/measurement/instrument_model.dart';
import 'package:oscillolab/core/measurement/instrument_range.dart';
import 'package:oscillolab/core/measurement/units.dart';

void main() {
  group('AssistantEngine', () {
    test('evaluarUsoDeRango advierte cuando la lectura usa <10% de la escala',
        () {
      final MensajeAsistente m = AssistantEngine.evaluarUsoDeRango(
        valorMostrado: 1.5,
        rangoMaximo: 200,
      );
      expect(m.tipo, TipoMensajeAsistente.consejo);
    });

    test(
        'evaluarUsoDeRango advierte cuando la lectura supera el 95% de la escala',
        () {
      final MensajeAsistente m = AssistantEngine.evaluarUsoDeRango(
        valorMostrado: 19.6,
        rangoMaximo: 20,
      );
      expect(m.tipo, TipoMensajeAsistente.advertencia);
    });

    test(
        'evaluarClasificacionError acierta cuando coincide con la clasificacion correcta',
        () {
      final MensajeAsistente m = AssistantEngine.evaluarClasificacionError(
        respuestaEstudiante: 'aleatorio',
        clasificacionCorrecta: 'aleatorio',
      );
      expect(m.tipo, TipoMensajeAsistente.exito);
    });

    test('evaluarClasificacionError corrige cuando no coincide', () {
      final MensajeAsistente m = AssistantEngine.evaluarClasificacionError(
        respuestaEstudiante: 'sistemático',
        clasificacionCorrecta: 'aleatorio',
      );
      expect(m.tipo, TipoMensajeAsistente.error);
    });

    test('evaluarCalibracion reporta exito si esta dentro de tolerancia', () {
      const CalibracionEstimada estimada =
          CalibracionEstimada(ganancia: 1.001, offset: 0.01);
      final MensajeAsistente m = AssistantEngine.evaluarCalibracion(estimada);
      expect(m.tipo, TipoMensajeAsistente.exito);
    });

    test('evaluarCalibracion reporta advertencia si esta fuera de tolerancia',
        () {
      const CalibracionEstimada estimada =
          CalibracionEstimada(ganancia: 1.10, offset: 0.01);
      final MensajeAsistente m = AssistantEngine.evaluarCalibracion(estimada);
      expect(m.tipo, TipoMensajeAsistente.advertencia);
    });

    test('sobrecarga siempre reporta advertencia con el nombre del instrumento',
        () {
      const InstrumentRange rango = InstrumentRange(
        etiqueta: '20 V',
        magnitud: Magnitud.voltajeDc,
        valorMaximo: 20,
        ruidoSigma: 0.008,
        resolucionDecimales: 2,
      );
      final InstrumentModel instrumento =
          InstrumentModel(nombre: 'DMM-X', rango: rango);
      final MensajeAsistente m = AssistantEngine.sobrecarga(instrumento);
      expect(m.tipo, TipoMensajeAsistente.advertencia);
      expect(m.texto, contains('DMM-X'));
    });
  });
}
