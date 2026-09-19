import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/measurement/error_propagation.dart';
import '../../../core/measurement/instrument_model.dart';
import '../model/propagation_case.dart';

class PropagacionState {
  const PropagacionState({
    required this.caso,
    required this.medicionV,
    required this.medicionI,
    this.potenciaCorrecta,
    this.incertidumbreCorrecta,
    this.respuestaEvaluada = false,
    this.aciertoValor,
    this.aciertoIncertidumbre,
  });

  final CasoPropagacion caso;
  final ResultadoMedicion medicionV;
  final ResultadoMedicion medicionI;
  final double? potenciaCorrecta;
  final double? incertidumbreCorrecta;
  final bool respuestaEvaluada;
  final bool? aciertoValor;
  final bool? aciertoIncertidumbre;
}

class PropagacionNotifier extends Notifier<PropagacionState> {
  @override
  PropagacionState build() {
    return _generarParaCaso(casosPropagacion.first);
  }

  PropagacionState _generarParaCaso(CasoPropagacion caso) {
    final InstrumentModel voltimetro =
        InstrumentModel(nombre: 'Voltimetro', rango: caso.rangoVoltaje);
    final InstrumentModel amperimetro =
        InstrumentModel(nombre: 'Amperimetro', rango: caso.rangoCorriente);
    return PropagacionState(
      caso: caso,
      medicionV: voltimetro.medir(caso.voltajeReal),
      medicionI: amperimetro.medir(caso.corrienteReal),
    );
  }

  void elegirCaso(CasoPropagacion caso) => state = _generarParaCaso(caso);

  void evaluar(
      {required double potenciaIngresada,
      required double incertidumbreIngresada}) {
    final double potenciaReal = state.medicionV.valor * state.medicionI.valor;
    final double incertidumbreReal = ErrorPropagation.combinarProductoCociente(
      valorA: state.medicionV.valor,
      incertidumbreA: state.medicionV.incertidumbre,
      valorB: state.medicionI.valor,
      incertidumbreB: state.medicionI.incertidumbre,
      resultado: potenciaReal,
    );

    final bool aciertoValor =
        (potenciaIngresada - potenciaReal).abs() <= 0.05 * potenciaReal.abs();
    final bool aciertoIncertidumbre =
        (incertidumbreIngresada - incertidumbreReal).abs() <=
            0.25 * incertidumbreReal.abs();

    state = PropagacionState(
      caso: state.caso,
      medicionV: state.medicionV,
      medicionI: state.medicionI,
      potenciaCorrecta: potenciaReal,
      incertidumbreCorrecta: incertidumbreReal,
      respuestaEvaluada: true,
      aciertoValor: aciertoValor,
      aciertoIncertidumbre: aciertoIncertidumbre,
    );
  }
}

final NotifierProvider<PropagacionNotifier, PropagacionState>
    propagacionProvider =
    NotifierProvider<PropagacionNotifier, PropagacionState>(
        PropagacionNotifier.new);
