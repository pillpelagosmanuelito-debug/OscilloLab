import '../measurement/calibration_engine.dart';
import '../measurement/instrument_model.dart';
import '../measurement/units.dart';
import 'assistant_message.dart';

/// Asistente técnico por reglas (sistema experto, sin IA generativa).
///
/// Principio de diseño no negociable: el asistente NUNCA recibe el valor
/// real oculto de una magnitud. Solo recibe lo mismo que el estudiante
/// puede ver: el resultado que el instrumento mostró en pantalla
/// ([ResultadoMedicion]), el rango/instrumento que el estudiante eligió,
/// y las respuestas que el estudiante ingresó. Esto es intencional: en un
/// laboratorio real, ni el instrumento ni un técnico ayudante conocen el
/// valor verdadero de antemano, solo lo que el instrumento reporta.
///
/// Se usan reglas explícitas (if/else sobre magnitudes físicas y
/// estadísticas) en vez de un LLM porque el dominio es cerrado y
/// determinista: hay una respuesta técnicamente correcta para "¿por qué
/// tu multímetro muestra OL?" y una regla la expresa mejor, más rápido y
/// sin alucinación que un modelo generativo. Ver docs/03 para la
/// justificación completa frente a IA generativa.
class AssistantEngine {
  /// El estudiante intentó medir y el instrumento mostró sobrecarga (OL).
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

  /// Evalúa si el estudiante eligió un rango razonable dado lo que el
  /// instrumento efectivamente mostró (no el valor real).
  static MensajeAsistente evaluarUsoDeRango({
    required double valorMostrado,
    required double rangoMaximo,
  }) {
    final double proporcion = valorMostrado.abs() / rangoMaximo;
    if (proporcion < 0.1) {
      return const MensajeAsistente(
        tipo: TipoMensajeAsistente.consejo,
        texto: 'La lectura usa menos del 10% de la escala seleccionada. '
            'Un rango más bajo suele dar mejor resolución relativa: '
            'considera bajar de escala si el instrumento lo permite.',
      );
    }
    if (proporcion > 0.95) {
      return const MensajeAsistente(
        tipo: TipoMensajeAsistente.advertencia,
        texto: 'Estás casi en el límite de la escala (>95%). Si el valor '
            'real fluctúa un poco más, el instrumento pasará a OL. '
            'Considera subir de escala.',
      );
    }
    return const MensajeAsistente(
      tipo: TipoMensajeAsistente.exito,
      texto: 'Buen uso de escala: la lectura ocupa una porción razonable '
          'del rango, lo que favorece una buena resolución relativa.',
    );
  }

  /// Evalúa la respuesta del estudiante sobre si un error es sistemático
  /// o aleatorio, dado el patrón correcto calculado por el motor.
  static MensajeAsistente evaluarClasificacionError({
    required String respuestaEstudiante,
    required String clasificacionCorrecta,
  }) {
    if (respuestaEstudiante == clasificacionCorrecta) {
      final String pista = clasificacionCorrecta == 'sistemático'
          ? 'porque el promedio de varias lecturas no se acerca al patrón: '
              'hay que calibrar (corregir ganancia/offset), no promediar más.'
          : 'porque promediar varias lecturas sí redujo la discrepancia '
              'frente al patrón: es ruido, no una falla de calibración.';
      return MensajeAsistente(
        tipo: TipoMensajeAsistente.exito,
        texto: 'Correcto, el error es $clasificacionCorrecta: $pista',
      );
    }
    return MensajeAsistente(
      tipo: TipoMensajeAsistente.error,
      texto: 'No es $respuestaEstudiante. Revisa qué le pasa al promedio de '
          'varias lecturas: si converge cerca del patrón, el error es '
          'aleatorio (ruido); si se estabiliza lejos del patrón de forma '
          'consistente, es sistemático (requiere calibración).',
    );
  }

  /// Evalúa el resultado de una calibración de dos puntos que el
  /// estudiante realizó, comparando su estimación contra la tolerancia
  /// técnica del instrumento (nunca contra los valores "inyectados" que
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
        : 'un error de OFFSET (desviación constante): revisa el ajuste de '
            'cero del instrumento.';
    return MensajeAsistente(
      tipo: TipoMensajeAsistente.advertencia,
      texto: 'El instrumento está fuera de tolerancia. Tu estimación '
          '(ganancia ${estimada.ganancia.toStringAsFixed(4)}, offset '
          '${estimada.offset.toStringAsFixed(4)}) indica $causa',
    );
  }

  /// Recomendación de instrumento para una magnitud, en el Módulo 1/5.
  /// Es una tabla de reglas fija (dominio cerrado), no un modelo.
  static MensajeAsistente recomendarInstrumento(String magnitudSolicitada) {
    const Map<String, String> reglas = {
      'voltaje_dc_estable': 'Multímetro digital en función de voltaje DC: '
          'suficiente resolución y no necesitas ver la forma de onda.',
      'senal_variable_en_tiempo': 'Osciloscopio: necesitas ver amplitud, '
          'frecuencia y forma de onda en el tiempo, algo que un multímetro '
          'no puede mostrar (solo entrega un número, no una gráfica).',
      'temperatura_proceso': 'Sensor de temperatura (termopar o RTD) con '
          'su acondicionador de señal, no un multímetro directo sobre el '
          'proceso.',
      'distancia_objeto': 'Sensor ultrasónico o infrarrojo, según el '
          'material del objetivo y el rango de distancia requerido.',
    };
    final String texto = reglas[magnitudSolicitada] ??
        'Especifica mejor la magnitud a medir para poder recomendar el '
            'instrumento adecuado.';
    return MensajeAsistente(tipo: TipoMensajeAsistente.consejo, texto: texto);
  }
}
