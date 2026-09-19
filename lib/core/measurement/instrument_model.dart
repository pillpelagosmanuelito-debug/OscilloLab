import 'dart:math';

import 'instrument_range.dart';
import 'noise_generator.dart';

/// Resultado de una medicion simulada. Cuando [enRango] es falso, el
/// instrumento habria mostrado "OL" (overload) y [valor] no debe usarse.
class ResultadoMedicion {
  const ResultadoMedicion({
    required this.valor,
    required this.enRango,
    required this.incertidumbre,
  });

  final double valor;
  final bool enRango;
  final double incertidumbre;

  /// Representacion tipo pantalla de instrumento, p. ej. "12.34 ± 0.02".
  String textoConIncertidumbre(int decimales) {
    if (!enRango) return 'OL';
    return '${valor.toStringAsFixed(decimales)} ± ${incertidumbre.toStringAsFixed(decimales)}';
  }
}

/// Modelo de instrumento con error sistematico (ganancia + offset), ruido
/// aleatorio gaussiano y resolucion de pantalla finita.
///
/// `lectura = round( valorReal * ganancia + offset + ruido , resolucion )`
///
/// Un instrumento "calibrado de fabrica" tiene ganancia=1.0, offset=0.0.
/// El modulo de Calibracion crea instrumentos con ganancia/offset
/// desviados para que el estudiante los detecte y corrija.
class InstrumentModel {
  InstrumentModel({
    required this.nombre,
    required this.rango,
    this.ganancia = 1.0,
    this.offset = 0.0,
    NoiseGenerator? generador,
  }) : _generador = generador ?? NoiseGenerator();

  final String nombre;
  final InstrumentRange rango;
  final double ganancia;
  final double offset;
  final NoiseGenerator _generador;

  /// Simula una medicion del [valorReal] (oculto para el estudiante).
  /// El asistente y la UI solo deben ver el resultado de este metodo,
  /// nunca [valorReal] directamente.
  ResultadoMedicion medir(double valorReal) {
    if (valorReal.abs() > rango.valorMaximo) {
      return ResultadoMedicion(
        valor: 0,
        enRango: false,
        incertidumbre: rango.incertidumbreDeclarada,
      );
    }
    final double crudo = valorReal * ganancia +
        offset +
        _generador.gaussian(rango.ruidoSigma);
    final double redondeado = _redondear(crudo, rango.resolucionDecimales);
    return ResultadoMedicion(
      valor: redondeado,
      enRango: true,
      incertidumbre: rango.incertidumbreDeclarada,
    );
  }

  double _redondear(double valor, int decimales) {
    final double factor = pow(10, decimales).toDouble();
    return (valor * factor).round() / factor;
  }

  InstrumentModel copyWith({double? ganancia, double? offset}) {
    return InstrumentModel(
      nombre: nombre,
      rango: rango,
      ganancia: ganancia ?? this.ganancia,
      offset: offset ?? this.offset,
      generador: _generador,
    );
  }
}
