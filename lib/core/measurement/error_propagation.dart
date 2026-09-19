import 'dart:math';

/// Utilidades de propagacion de incertidumbre para el Modulo 3 (Errores).
///
/// Cuando una magnitud se calcula a partir de otras medidas (p. ej.
/// potencia P = V * I), su incertidumbre no es la suma simple de las
/// incertidumbres de entrada: para errores independientes se combinan
/// en cuadratura (suma de varianzas). Esta es la regla que ISO/IEC GUM
/// (Guide to the expression of Uncertainty in Measurement) establece
/// para magnitudes derivadas de mediciones independientes.
class ErrorPropagation {
  /// Incertidumbre absoluta de una suma o resta: se combinan en
  /// cuadratura las incertidumbres absolutas.
  /// U(a±b) = sqrt(Ua^2 + Ub^2)
  static double combinarSumaResta(double incertidumbreA, double incertidumbreB) {
    return sqrt(incertidumbreA * incertidumbreA + incertidumbreB * incertidumbreB);
  }

  /// Incertidumbre relativa de un producto o cociente: se combinan en
  /// cuadratura las incertidumbres RELATIVAS, luego se convierte a
  /// incertidumbre absoluta multiplicando por el resultado.
  /// Ur(a*b) = sqrt(Ur(a)^2 + Ur(b)^2)  =>  U(a*b) = |a*b| * Ur(a*b)
  static double combinarProductoCociente({
    required double valorA,
    required double incertidumbreA,
    required double valorB,
    required double incertidumbreB,
    required double resultado,
  }) {
    if (valorA == 0 || valorB == 0) return double.infinity;
    final double relA = incertidumbreA / valorA.abs();
    final double relB = incertidumbreB / valorB.abs();
    final double relCombinada = sqrt(relA * relA + relB * relB);
    return resultado.abs() * relCombinada;
  }

  /// Clasifica un error como "sistematico" (afecta siempre en la misma
  /// direccion; se corrige con calibracion) o "aleatorio" (varia lectura
  /// a lectura; se reduce promediando, nunca se elimina del todo).
  ///
  /// Regla usada en los ejercicios del Modulo 3: si repetir la medicion
  /// N veces y promediar reduce la discrepancia frente al patron, el
  /// error dominante es aleatorio; si el promedio converge a un valor
  /// consistentemente desviado del patron, el error es sistematico.
  static String clasificarError({
    required double desviacionUnaLectura,
    required double desviacionPromedioNLecturas,
  }) {
    final double reduccion = 1 - (desviacionPromedioNLecturas / desviacionUnaLectura).abs();
    return reduccion > 0.5 ? 'aleatorio' : 'sistematico';
  }
}
