import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/seleccion_escenario.dart';

class SeleccionState {
  const SeleccionState({
    required this.indice,
    required this.correctas,
    required this.respondido,
    this.opcionElegida,
    this.esCorrecto,
  });

  final int indice;
  final int correctas;
  final bool respondido;
  final String? opcionElegida;
  final bool? esCorrecto;

  bool get terminado => indice >= escenariosSeleccion.length;

  EscenarioSeleccion? get escenarioActual =>
      terminado ? null : escenariosSeleccion[indice];

  SeleccionState copyWith({
    int? indice,
    int? correctas,
    bool? respondido,
    String? opcionElegida,
    bool? esCorrecto,
  }) {
    return SeleccionState(
      indice: indice ?? this.indice,
      correctas: correctas ?? this.correctas,
      respondido: respondido ?? this.respondido,
      opcionElegida: opcionElegida,
      esCorrecto: esCorrecto,
    );
  }
}

class SeleccionNotifier extends Notifier<SeleccionState> {
  @override
  SeleccionState build() {
    return const SeleccionState(indice: 0, correctas: 0, respondido: false);
  }

  void responder(String idInstrumentoElegido) {
    final EscenarioSeleccion? escenario = state.escenarioActual;
    if (escenario == null || state.respondido) return;
    final bool correcto = idInstrumentoElegido == escenario.idCorrectoId;
    state = state.copyWith(
      respondido: true,
      opcionElegida: idInstrumentoElegido,
      esCorrecto: correcto,
      correctas: correcto ? state.correctas + 1 : state.correctas,
    );
  }

  void siguiente() {
    state = SeleccionState(
      indice: state.indice + 1,
      correctas: state.correctas,
      respondido: false,
    );
  }

  void reiniciar() {
    state = const SeleccionState(indice: 0, correctas: 0, respondido: false);
  }
}

final NotifierProvider<SeleccionNotifier, SeleccionState> seleccionProvider =
    NotifierProvider<SeleccionNotifier, SeleccionState>(SeleccionNotifier.new);
