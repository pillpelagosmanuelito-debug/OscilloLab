import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/assistant/assistant_engine.dart';
import '../../../core/assistant/assistant_message.dart';
import '../../../core/measurement/calibration_engine.dart';
import '../model/calibration_case.dart';

class CalibracionState {
  const CalibracionState({
    required this.caso,
    this.promedioBajo,
    this.promedioAlto,
    this.estimada,
    this.mensajeAsistente,
  });

  final CasoCalibracion caso;
  final double? promedioBajo;
  final double? promedioAlto;
  final CalibracionEstimada? estimada;
  final MensajeAsistente? mensajeAsistente;

  bool get medido => estimada != null;

  CalibracionState copyWith({
    double? promedioBajo,
    double? promedioAlto,
    CalibracionEstimada? estimada,
    MensajeAsistente? mensajeAsistente,
  }) {
    return CalibracionState(
      caso: caso,
      promedioBajo: promedioBajo ?? this.promedioBajo,
      promedioAlto: promedioAlto ?? this.promedioAlto,
      estimada: estimada ?? this.estimada,
      mensajeAsistente: mensajeAsistente ?? this.mensajeAsistente,
    );
  }
}

class CalibracionNotifier extends Notifier<CalibracionState> {
  static const int muestrasPorPatron = 25;

  @override
  CalibracionState build() {
    return CalibracionState(caso: casosCalibracion.first);
  }

  void elegirCaso(CasoCalibracion caso) => state = CalibracionState(caso: caso);

  /// Toma [muestrasPorPatron] lecturas en cada patron de referencia y
  /// resuelve la calibracion de dos puntos, exactamente el mismo
  /// procedimiento validado en calib/measurement_model.py
  /// (test_two_point_calibration).
  void medirYCalibrar() {
    final instrumento = state.caso.construirInstrumento();

    final List<double> lecturasBajo = List.generate(
      muestrasPorPatron,
      (_) => instrumento.medir(state.caso.patronBajo).valor,
    );
    final List<double> lecturasAlto = List.generate(
      muestrasPorPatron,
      (_) => instrumento.medir(state.caso.patronAlto).valor,
    );

    final double promedioBajo = CalibrationEngine.promedio(lecturasBajo);
    final double promedioAlto = CalibrationEngine.promedio(lecturasAlto);

    final CalibracionEstimada estimada = CalibrationEngine.calibrarDosPuntos(
      patronBajo: state.caso.patronBajo,
      promedioLecturaBaja: promedioBajo,
      patronAlto: state.caso.patronAlto,
      promedioLecturaAlta: promedioAlto,
    );

    state = state.copyWith(
      promedioBajo: promedioBajo,
      promedioAlto: promedioAlto,
      estimada: estimada,
      mensajeAsistente: AssistantEngine.evaluarCalibracion(estimada),
    );
  }
}

final NotifierProvider<CalibracionNotifier, CalibracionState> calibracionProvider =
    NotifierProvider<CalibracionNotifier, CalibracionState>(CalibracionNotifier.new);
