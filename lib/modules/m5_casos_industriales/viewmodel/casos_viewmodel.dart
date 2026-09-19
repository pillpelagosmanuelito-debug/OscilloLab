import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/measurement/instrument_model.dart';
import '../../../core/measurement/instrument_range.dart';
import '../model/industrial_case.dart';

enum PasoCaso { seleccionInstrumento, medicion, decisionAccion, resultado }

class CasoIndustrialState {
  const CasoIndustrialState({
    required this.indice,
    required this.puntaje,
    required this.paso,
    this.instrumentoElegidoId,
    this.instrumentoCorrecto,
    this.resultadoMedicion,
    this.accionElegidaId,
    this.accionCorrecta,
  });

  final int indice;
  final int puntaje;
  final PasoCaso paso;
  final String? instrumentoElegidoId;
  final bool? instrumentoCorrecto;
  final ResultadoMedicion? resultadoMedicion;
  final String? accionElegidaId;
  final bool? accionCorrecta;

  bool get terminado => indice >= casosIndustriales.length;
  CasoIndustrial? get casoActual =>
      terminado ? null : casosIndustriales[indice];

  CasoIndustrialState copyWith({
    int? indice,
    int? puntaje,
    PasoCaso? paso,
    String? instrumentoElegidoId,
    bool? instrumentoCorrecto,
    ResultadoMedicion? resultadoMedicion,
    String? accionElegidaId,
    bool? accionCorrecta,
  }) {
    return CasoIndustrialState(
      indice: indice ?? this.indice,
      puntaje: puntaje ?? this.puntaje,
      paso: paso ?? this.paso,
      instrumentoElegidoId: instrumentoElegidoId ?? this.instrumentoElegidoId,
      instrumentoCorrecto: instrumentoCorrecto ?? this.instrumentoCorrecto,
      resultadoMedicion: resultadoMedicion ?? this.resultadoMedicion,
      accionElegidaId: accionElegidaId ?? this.accionElegidaId,
      accionCorrecta: accionCorrecta ?? this.accionCorrecta,
    );
  }
}

class CasosIndustrialesNotifier extends Notifier<CasoIndustrialState> {
  @override
  CasoIndustrialState build() {
    return const CasoIndustrialState(
        indice: 0, puntaje: 0, paso: PasoCaso.seleccionInstrumento);
  }

  void elegirInstrumento(String idElegido) {
    final CasoIndustrial caso = state.casoActual!;
    final bool correcto = idElegido == caso.instrumentoCorrectoId;
    state = state.copyWith(
      instrumentoElegidoId: idElegido,
      instrumentoCorrecto: correcto,
      puntaje: correcto ? state.puntaje + 1 : state.puntaje,
      paso: PasoCaso.medicion,
    );
  }

  void medir() {
    final CasoIndustrial caso = state.casoActual!;
    final InstrumentRange rango = caso.rango;
    final InstrumentModel instrumento =
        InstrumentModel(nombre: 'Instrumento de campo', rango: rango);
    final ResultadoMedicion resultado = instrumento.medir(caso.valorReal);
    state = state.copyWith(
        resultadoMedicion: resultado, paso: PasoCaso.decisionAccion);
  }

  void elegirAccion(String idAccion) {
    final CasoIndustrial caso = state.casoActual!;
    final bool correcto = idAccion == caso.accionCorrectaId;
    state = state.copyWith(
      accionElegidaId: idAccion,
      accionCorrecta: correcto,
      puntaje: correcto ? state.puntaje + 1 : state.puntaje,
      paso: PasoCaso.resultado,
    );
  }

  void siguienteCaso() {
    state = CasoIndustrialState(
      indice: state.indice + 1,
      puntaje: state.puntaje,
      paso: PasoCaso.seleccionInstrumento,
    );
  }

  void reiniciar() {
    state = const CasoIndustrialState(
        indice: 0, puntaje: 0, paso: PasoCaso.seleccionInstrumento);
  }
}

final NotifierProvider<CasosIndustrialesNotifier, CasoIndustrialState>
    casosIndustrialesProvider =
    NotifierProvider<CasosIndustrialesNotifier, CasoIndustrialState>(
        CasosIndustrialesNotifier.new);
