import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/assistant/assistant_engine.dart';
import '../../../core/assistant/assistant_message.dart';
import '../../../core/measurement/instrument_model.dart';
import '../../../core/measurement/noise_generator.dart';
import '../model/scenario_catalog.dart';

class OsciloscopioState {
  const OsciloscopioState({
    required this.escenario,
    required this.muestras,
    this.resultadoVpp,
    this.resultadoFrecuencia,
    this.mensajeAsistente,
  });

  final EscenarioOsciloscopio escenario;
  final List<double> muestras; // Para dibujar la forma de onda en pantalla.
  final ResultadoMedicion? resultadoVpp;
  final ResultadoMedicion? resultadoFrecuencia;
  final MensajeAsistente? mensajeAsistente;

  OsciloscopioState copyWith({
    EscenarioOsciloscopio? escenario,
    List<double>? muestras,
    ResultadoMedicion? resultadoVpp,
    ResultadoMedicion? resultadoFrecuencia,
    MensajeAsistente? mensajeAsistente,
  }) {
    return OsciloscopioState(
      escenario: escenario ?? this.escenario,
      muestras: muestras ?? this.muestras,
      resultadoVpp: resultadoVpp,
      resultadoFrecuencia: resultadoFrecuencia,
      mensajeAsistente: mensajeAsistente,
    );
  }
}

class OsciloscopioNotifier extends Notifier<OsciloscopioState> {
  final NoiseGenerator _ruido = NoiseGenerator();

  @override
  OsciloscopioState build() {
    final EscenarioOsciloscopio primero = escenariosOsciloscopio.first;
    return OsciloscopioState(escenario: primero, muestras: _generarMuestras(primero));
  }

  /// Genera 200 muestras de la senal para dibujarla en pantalla, con el
  /// mismo ruido gaussiano que el motor de medicion aplicaria a una
  /// lectura real (asi la pantalla se ve tan "sucia" como la medicion).
  List<double> _generarMuestras(EscenarioOsciloscopio escenario) {
    const int n = 200;
    const double ciclosVisibles = 3.0;
    final double amplitud = escenario.amplitudPicoPicoReal / 2;
    final double sigmaVisual = escenario.rangoVoltaje.ruidoSigma * 3;
    return List<double>.generate(n, (i) {
      final double t = (i / n) * ciclosVisibles * 2 * pi;
      final double base = escenario.formaOnda == 'seno' ? sin(t) : (sin(t) >= 0 ? 1.0 : -1.0);
      return base * amplitud + _ruido.gaussian(sigmaVisual);
    });
  }

  void elegirEscenario(EscenarioOsciloscopio escenario) {
    state = OsciloscopioState(escenario: escenario, muestras: _generarMuestras(escenario));
  }

  void medirVpp() {
    final InstrumentModel instrumento = InstrumentModel(
      nombre: 'Osciloscopio (Vpp)',
      rango: state.escenario.rangoVoltaje,
    );
    final ResultadoMedicion resultado = instrumento.medir(state.escenario.amplitudPicoPicoReal);
    final MensajeAsistente mensaje = !resultado.enRango
        ? AssistantEngine.sobrecarga(instrumento)
        : AssistantEngine.evaluarUsoDeRango(
            valorMostrado: resultado.valor,
            rangoMaximo: state.escenario.rangoVoltaje.valorMaximo,
          );
    state = state.copyWith(resultadoVpp: resultado, mensajeAsistente: mensaje);
  }

  void medirFrecuencia() {
    final InstrumentModel instrumento = InstrumentModel(
      nombre: 'Osciloscopio (frecuencia)',
      rango: state.escenario.rangoFrecuencia,
    );
    final ResultadoMedicion resultado = instrumento.medir(state.escenario.frecuenciaHzReal);
    state = state.copyWith(resultadoFrecuencia: resultado);
  }
}

final NotifierProvider<OsciloscopioNotifier, OsciloscopioState> osciloscopioProvider =
    NotifierProvider<OsciloscopioNotifier, OsciloscopioState>(OsciloscopioNotifier.new);
