import 'package:flutter_test/flutter_test.dart';
import 'package:oscillolab/core/measurement/error_propagation.dart';

void main() {
  group('ErrorPropagation', () {
    test('combina incertidumbres relativas en cuadratura para un producto', () {
      // P = V * I = 12 * 2 = 24
      // Ur(V) = 0.01/12, Ur(I) = 0.005/2
      const double v = 12.0, uV = 0.01, i = 2.0, uI = 0.005;
      const double p = v * i;
      final double up = ErrorPropagation.combinarProductoCociente(
        valorA: v,
        incertidumbreA: uV,
        valorB: i,
        incertidumbreB: uI,
        resultado: p,
      );
      // Calculo manual de referencia:
      // Ur = sqrt((0.01/12)^2 + (0.005/2)^2) ≈ sqrt(6.94e-7 + 6.25e-6) ≈ 0.002625
      // U(P) = 24 * 0.002625 ≈ 0.063
      expect(up, closeTo(0.063, 0.002));
    });

    test('combina incertidumbres absolutas en cuadratura para suma/resta', () {
      final double u = ErrorPropagation.combinarSumaResta(0.03, 0.04);
      expect(u, closeTo(0.05, 0.0001)); // 3-4-5 triangulo: sqrt(0.03^2+0.04^2)=0.05
    });

    test('clasifica como aleatorio cuando el promedio reduce la discrepancia', () {
      final String clasificacion = ErrorPropagation.clasificarError(
        desviacionUnaLectura: 0.5,
        desviacionPromedioNLecturas: 0.05,
      );
      expect(clasificacion, 'aleatorio');
    });

    test('clasifica como sistematico cuando el promedio no reduce la discrepancia', () {
      final String clasificacion = ErrorPropagation.clasificarError(
        desviacionUnaLectura: 0.5,
        desviacionPromedioNLecturas: 0.48,
      );
      expect(clasificacion, 'sistematico');
    });
  });
}
