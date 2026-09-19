import 'units.dart';

/// Un rango/escala seleccionable de un instrumento (p. ej. multimetro en
/// escala de 20V, o resistencia en escala de 2kΩ).
///
/// [ruidoSigma] y [resolucionDecimales] son los parametros que el motor de
/// medicion usa para simular una lectura realista; fueron calibrados y
/// validados estadisticamente en `calib/measurement_model.py` antes de
/// portarse aqui (ver docs/04_Guia_Calibracion_Motor.md).
class InstrumentRange {
  const InstrumentRange({
    required this.etiqueta,
    required this.magnitud,
    required this.valorMaximo,
    required this.ruidoSigma,
    required this.resolucionDecimales,
  });

  final String etiqueta;
  final Magnitud magnitud;
  final double valorMaximo;
  final double ruidoSigma;
  final int resolucionDecimales;

  /// Incertidumbre declarada U = 2*sigma (cobertura ~95%) + medio digito de
  /// resolucion. Es deliberadamente conservadora: garantiza cobertura >=95%,
  /// no exactamente 95% (practica estandar de instrumentacion).
  double get incertidumbreDeclarada {
    final double medioDigito = 0.5 * _pow10(-resolucionDecimales);
    return 2 * ruidoSigma + medioDigito;
  }

  static double _pow10(int exp) {
    double result = 1.0;
    if (exp >= 0) {
      for (int i = 0; i < exp; i++) {
        result *= 10;
      }
    } else {
      for (int i = 0; i < -exp; i++) {
        result /= 10;
      }
    }
    return result;
  }
}
