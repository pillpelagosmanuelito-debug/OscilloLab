import 'dart:math';

/// Generador de ruido gaussiano (Box-Muller) para simular el ruido
/// electronico y de cuantizacion de un instrumento real.
///
/// Se usa una unica instancia con semilla opcional para que las pruebas
/// unitarias sean reproducibles; en produccion se usa sin semilla.
class NoiseGenerator {
  NoiseGenerator({int? seed})
      : _random = seed != null ? Random(seed) : Random();

  final Random _random;
  double? _spare;

  /// Devuelve una muestra de una distribucion normal N(0, sigma^2).
  double gaussian(double sigma) {
    if (sigma <= 0) return 0.0;
    if (_spare != null) {
      final double value = _spare!;
      _spare = null;
      return value * sigma;
    }
    double u, v, s;
    do {
      u = _random.nextDouble() * 2 - 1;
      v = _random.nextDouble() * 2 - 1;
      s = u * u + v * v;
    } while (s >= 1 || s == 0);
    final double mul = sqrt(-2.0 * log(s) / s);
    _spare = v * mul;
    return u * mul * sigma;
  }
}
