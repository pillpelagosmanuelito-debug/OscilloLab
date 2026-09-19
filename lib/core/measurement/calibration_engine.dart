/// Resultado de una calibración de dos puntos: la ganancia y el offset
/// estimados de un instrumento a partir de dos patrones de referencia
/// conocidos.
class CalibracionEstimada {
  const CalibracionEstimada({required this.ganancia, required this.offset});

  final double ganancia;
  final double offset;

  /// Un instrumento se considera "dentro de tolerancia" si su ganancia está
  /// a menos de [toleranciaGanancia] de 1.0 y su offset a menos de
  /// [toleranciaOffset] de 0.0.
  bool dentroDeTolerancia({
    double toleranciaGanancia = 0.02,
    double toleranciaOffset = 0.05,
  }) {
    return (ganancia - 1.0).abs() <= toleranciaGanancia &&
        offset.abs() <= toleranciaOffset;
  }
}

/// Calibración de dos puntos: dados dos patrones de referencia conocidos
/// (valor bajo y valor alto) y el promedio de varias lecturas del
/// instrumento en cada patrón, resuelve el sistema lineal
///
///   lecturaPromedio = ganancia * valorReal + offset
///
/// para (ganancia, offset). Este es el mismo procedimiento que un técnico
/// de instrumentación real usa para calibrar un multímetro contra un
/// patrón trazable.
///
/// Validado estadísticamente en `calib/measurement_model.py`
/// (test_two_point_calibration): con ganancia inyectada 1.05 y offset
/// inyectado 0.15, la estimación recupera 1.04999... y 0.15035...
class CalibrationEngine {
  static CalibracionEstimada calibrarDosPuntos({
    required double patronBajo,
    required double promedioLecturaBaja,
    required double patronAlto,
    required double promedioLecturaAlta,
  }) {
    assert(patronAlto != patronBajo, 'Los dos patrones deben ser distintos');
    final double ganancia =
        (promedioLecturaAlta - promedioLecturaBaja) / (patronAlto - patronBajo);
    final double offset = promedioLecturaBaja - ganancia * patronBajo;
    return CalibracionEstimada(ganancia: ganancia, offset: offset);
  }

  static double promedio(List<double> lecturas) {
    if (lecturas.isEmpty) return 0.0;
    return lecturas.reduce((a, b) => a + b) / lecturas.length;
  }
}
