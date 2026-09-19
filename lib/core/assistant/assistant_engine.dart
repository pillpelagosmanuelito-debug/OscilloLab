import '../measurement/calibration_engine.dart';
import '../measurement/instrument_model.dart';
import '../measurement/units.dart';
import 'assistant_message.dart';

/// Asistente tecnico por reglas (sistema experto, sin IA generativa).
///
/// Principio de diseno no negociable: el asistente NUNCA recibe el valor
/// real oculto de una magnitud. Solo recibe lo mismo que el estudiante
/// puede ver: el resultado que el instrumento mostro en pantalla
/// ([ResultadoMedicion]), el rango/instrumento que el estudiante elegio,
/// y las respuestas que el estudiante ingreso. Esto es intencional: en un
/// laboratorio real, ni el instrumento ni un tecnico ayudante conocen el
/// valor verdadero de antemano, solo lo que el instrumento reporta.
///
/// Se usa reglas explicitas (if/else sobre magnitudes fisicas y
/// estadisticas) en vez de un LLM porque el dominio es cerrado y
/// determinista: hay una respuesta tecnicamente correcta para "¿por que
/// tu multimetro muestra OL?" y una regla la expresa mejor, mas rapido y
/// sin alucinacion que un modelo generativo. Ver docs/03 para la
/// justificacion completa frente a IA generativa.
class AssistantEngine {
  /// El estudiante intento medir y el instrumento mostro sobrecarga (OL).
  static MensajeAsistente sobrecarga(InstrumentModel instrumento) {
    return MensajeAsistente(
      tipo: TipoMensajeAsistente.advertencia,
      texto: 'El instrumento muestra "OL" (overload): la magnitud supera el '
          'rango de ${instrumento.rango.valorMaximo.toStringAsFixed(0)} '
          '${instrumento.rango.magnitud.simbolo} que seleccionaste. '
          'Sube a la siguiente escala del ${instrumento.nombre} antes de '
          'volver a medir.',
    );
  }

  /// Evalua si el estudiante eligio un rango razonable dado lo que el
  /// instrumento efectivamente mostro (no el valor real).
  static MensajeAsistente evaluarUsoDeRango({
    required double valorMostrado,
    required double rangoMaximo,
  }) {
    final double proporcion = valorMostrado.abs() / rangoMaximo;
    if (proporcion < 0.1) {
      return const MensajeAsistente(
        tipo: TipoMensajeAsistente.consejo,
        texto: 'La lectura usa menos del 10% de la escala seleccionada. '
            'Un rango mas bajo suele dar mejor resolucion relativa: '
            'considera bajar de escala si el instrumento lo permite.',
      );
    }
    if (proporcion > 0.95) {
      return const MensajeAsistente(
        tipo: TipoMensajeAsistente.advertencia,
        texto: 'Estas casi en el limite de la escala (>95%). Si el valor '
            'real fluctua un poco mas, el instrumento pasara a OL. '
            'Considera subir de escala.',
      );
    }
    return const MensajeAsistente(
      tipo: TipoMensajeAsistente.exito,
      texto: 'Buen uso de escala: la lectura ocupa una porcion razonable '
          'del rango, lo que favorece una buena resolucion relativa.',
    );
  }

  /// Evalua la respuesta del estudiante sobre si un error es sistematico
  /// o aleatorio, dado el patron correcto calculado por el motor.
  static MensajeAsistente evaluarClasificacionError({
    required String respuestaEstudiante,
    required String clasificacionCorrecta,
  }) {
    if (respuestaEstudiante == clasificacionCorrecta) {
      final String pista = clasificacionCorrecta == 'sistematico'
          ? 'porque el promedio de varias lecturas no se acerca al patron: '
              'hay que calibrar (corregir ganancia/offset), no promediar mas.'
          : 'porque promediar varias lecturas si redujo la discrepancia '
              'frente al patron: es ruido, no una falla de calibracion.';
      return MensajeAsistente(
        tipo: TipoMensajeAsistente.exito,
        texto: 'Correcto, el error es $clasificacionCorrecta: $pista',
      );
    }
    return MensajeAsistente(
      tipo: TipoMensajeAsistente.error,
      texto: 'No es $respuestaEstudiante. Revisa que le pasa al promedio de '
          'varias lecturas: si converge cerca del patron, el error es '
          'aleatorio (ruido); si se estabiliza lejos del patron de forma '
          'consistente, es sistematico (requiere calibracion).',
    );
  }

  /// Evalua el resultado de una calibracion de dos puntos que el
  /// estudiante realizo, comparando su estimacion contra la tolerancia
  /// tecnica del instrumento (nunca contra los valores "inyectados" que
  /// el estudiante no puede ver).
  static MensajeAsistente evaluarCalibracion(CalibracionEstimada estimada) {
    if (estimada.dentroDeTolerancia()) {
      return MensajeAsistente(
        tipo: TipoMensajeAsistente.exito,
        texto: 'El instrumento queda dentro de tolerancia: ganancia '
            '${estimada.ganancia.toStringAsFixed(4)} (ideal 1.0000), offset '
            '${estimada.offset.toStringAsFixed(4)} (ideal 0.0000). No se '
            'requiere ajuste.',
      );
    }
    final String causa = (estimada.ganancia - 1.0).abs() > 0.02
        ? 'un error de GANANCIA (la pendiente de su respuesta no es 1): '
            'revisa el atenuador/amplificador de entrada del instrumento.'
        : 'un error de OFFSET (desviacion constante): revisa el ajuste de '
            'cero del instrumento.';
    return MensajeAsistente(
      tipo: TipoMensajeAsistente.advertencia,
      texto: 'El instrumento esta fuera de tolerancia. Tu estimacion '
          '(ganancia ${estimada.ganancia.toStringAsFixed(4)}, offset '
          '${estimada.offset.toStringAsFixed(4)}) indica $causa',
    );
  }

  /// Recomendacion de instrumento para una magnitud, en el Modulo 1/5.
  /// Es una tabla de reglas fija (dominio cerrado), no un modelo.
  static MensajeAsistente recomendarInstrumento(String magnitudSolicitada) {
    const Map<String, String> reglas = {
      'voltaje_dc_estable': 'Multimetro digital en funcion de voltaje DC: '
          'suficiente resolucion y no necesitas ver la forma de onda.',
      'senal_variable_en_tiempo': 'Osciloscopio: necesitas ver amplitud, '
          'frecuencia y forma de onda en el tiempo, algo que un multimetro '
          'no puede mostrar (solo entrega un numero, no una grafica).',
      'temperatura_proceso': 'Sensor de temperatura (termopar o RTD) con '
          'su acondicionador de senal, no un multimetro directo sobre el '
          'proceso.',
      'distancia_objeto': 'Sensor ultrasonico o infrarrojo, segun el '
          'material del objetivo y el rango de distancia requerido.',
    };
    final String texto = reglas[magnitudSolicitada] ??
        'Especifica mejor la magnitud a medir para poder recomendar el '
            'instrumento adecuado.';
    return MensajeAsistente(tipo: TipoMensajeAsistente.consejo, texto: texto);
  }
}
