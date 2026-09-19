import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/assistant/assistant_engine.dart';
import '../../../core/assistant/assistant_message.dart';
import '../../../core/measurement/instrument_model.dart';
import '../../../core/measurement/instrument_range.dart';
import '../model/scenario_catalog.dart';

class MultimetroState {
  const MultimetroState({
    required this.escenario,
    required this.rangoSeleccionado,
    this.resultado,
    this.mensajeAsistente,
  });

  final EscenarioMultimetro escenario;
  final InstrumentRange rangoSeleccionado;
  final ResultadoMedicion? resultado;
  final MensajeAsistente? mensajeAsistente;

  MultimetroState copyWith({
    EscenarioMultimetro? escenario,
    InstrumentRange? rangoSeleccionado,
    ResultadoMedicion? resultado,
    MensajeAsistente? mensajeAsistente,
  }) {
    return MultimetroState(
      escenario: escenario ?? this.escenario,
      rangoSeleccionado: rangoSeleccionado ?? this.rangoSeleccionado,
      resultado: resultado,
      mensajeAsistente: mensajeAsistente,
    );
  }
}

class MultimetroNotifier extends Notifier<MultimetroState> {
  @override
  MultimetroState build() {
    final EscenarioMultimetro primero = escenariosMultimetro.first;
    return MultimetroState(
        escenario: primero, rangoSeleccionado: primero.rangos[1]);
  }

  void elegirEscenario(EscenarioMultimetro escenario) {
    state = MultimetroState(
      escenario: escenario,
      rangoSeleccionado: escenario.rangos[escenario.rangos.length ~/ 2],
    );
  }

  void elegirRango(InstrumentRange rango) {
    state = state.copyWith(
        rangoSeleccionado: rango, resultado: null, mensajeAsistente: null);
  }

  void medir() {
    final InstrumentModel instrumento = InstrumentModel(
      nombre: 'Multímetro digital',
      rango: state.rangoSeleccionado,
    );
    final ResultadoMedicion resultado =
        instrumento.medir(state.escenario.valorReal);

    final MensajeAsistente mensaje = !resultado.enRango
        ? AssistantEngine.sobrecarga(instrumento)
        : AssistantEngine.evaluarUsoDeRango(
            valorMostrado: resultado.valor,
            rangoMaximo: state.rangoSeleccionado.valorMaximo,
          );

    state = state.copyWith(resultado: resultado, mensajeAsistente: mensaje);
  }
}

final NotifierProvider<MultimetroNotifier, MultimetroState> multimetroProvider =
    NotifierProvider<MultimetroNotifier, MultimetroState>(
        MultimetroNotifier.new);
