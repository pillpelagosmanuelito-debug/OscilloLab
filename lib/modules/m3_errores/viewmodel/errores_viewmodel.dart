import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/assistant/assistant_engine.dart';
import '../../../core/assistant/assistant_message.dart';
import '../../../core/measurement/error_propagation.dart';
import '../../../core/measurement/instrument_model.dart';
import '../model/error_case.dart';

class ErroresState {
  const ErroresState({
    required this.indice,
    required this.correctas,
    this.lecturaUnica,
    this.promedioLecturas,
    this.clasificacionCorrecta,
    this.respuestaElegida,
    this.mensajeAsistente,
  });

  final int indice;
  final int correctas;
  final double? lecturaUnica;
  final double? promedioLecturas;
  final String? clasificacionCorrecta;
  final String? respuestaElegida;
  final MensajeAsistente? mensajeAsistente;

  bool get terminado => indice >= casosError.length;
  bool get medido => lecturaUnica != null;
  bool get respondido => respuestaElegida != null;
  CasoError? get casoActual => terminado ? null : casosError[indice];

  ErroresState copyWith({
    int? indice,
    int? correctas,
    double? lecturaUnica,
    double? promedioLecturas,
    String? clasificacionCorrecta,
    String? respuestaElegida,
    MensajeAsistente? mensajeAsistente,
  }) {
    return ErroresState(
      indice: indice ?? this.indice,
      correctas: correctas ?? this.correctas,
      lecturaUnica: lecturaUnica ?? this.lecturaUnica,
      promedioLecturas: promedioLecturas ?? this.promedioLecturas,
      clasificacionCorrecta:
          clasificacionCorrecta ?? this.clasificacionCorrecta,
      respuestaElegida: respuestaElegida,
      mensajeAsistente: mensajeAsistente,
    );
  }
}

class ErroresNotifier extends Notifier<ErroresState> {
  static const int muestrasParaPromedio = 30;

  @override
  ErroresState build() {
    return const ErroresState(indice: 0, correctas: 0);
  }

  /// Toma una lectura unica y un promedio de 30 lecturas del instrumento
  /// del caso actual, y deriva la clasificacion CORRECTA aplicando la
  /// misma regla que el motor de propagacion de errores (no un valor
  /// codificado a mano): si promediar reduce la discrepancia frente al
  /// patron en mas del 50%, el error dominante es aleatorio.
  void medir() {
    final CasoError? caso = state.casoActual;
    if (caso == null) return;
    final InstrumentModel instrumento = caso.construirInstrumento();

    final double unica = instrumento.medir(caso.patronReferencia).valor;
    double suma = 0;
    for (int i = 0; i < muestrasParaPromedio; i++) {
      suma += instrumento.medir(caso.patronReferencia).valor;
    }
    final double promedio = suma / muestrasParaPromedio;

    final double desviacionUnica = (unica - caso.patronReferencia).abs();
    final double desviacionPromedio = (promedio - caso.patronReferencia).abs();
    final String clasificacion = ErrorPropagation.clasificarError(
      desviacionUnaLectura: desviacionUnica,
      desviacionPromedioNLecturas: desviacionPromedio,
    );

    state = state.copyWith(
      lecturaUnica: unica,
      promedioLecturas: promedio,
      clasificacionCorrecta: clasificacion,
    );
  }

  void responder(String clasificacionElegida) {
    if (state.clasificacionCorrecta == null || state.respondido) return;
    final bool correcto = clasificacionElegida == state.clasificacionCorrecta;
    final MensajeAsistente mensaje = AssistantEngine.evaluarClasificacionError(
      respuestaEstudiante: clasificacionElegida,
      clasificacionCorrecta: state.clasificacionCorrecta!,
    );
    state = state.copyWith(
      respuestaElegida: clasificacionElegida,
      correctas: correcto ? state.correctas + 1 : state.correctas,
      mensajeAsistente: mensaje,
    );
  }

  void siguiente() {
    state = ErroresState(indice: state.indice + 1, correctas: state.correctas);
  }

  void reiniciar() {
    state = const ErroresState(indice: 0, correctas: 0);
  }
}

final NotifierProvider<ErroresNotifier, ErroresState> erroresProvider =
    NotifierProvider<ErroresNotifier, ErroresState>(ErroresNotifier.new);
