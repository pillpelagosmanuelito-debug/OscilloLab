import 'package:flutter_test/flutter_test.dart';
import 'package:oscillolab/core/measurement/calibration_engine.dart';
import 'package:oscillolab/core/measurement/instrument_model.dart';
import 'package:oscillolab/core/measurement/instrument_range.dart';
import 'package:oscillolab/core/measurement/noise_generator.dart';
import 'package:oscillolab/core/measurement/units.dart';

void main() {
  group('CalibrationEngine', () {
    test('recupera ganancia y offset inyectados mediante calibracion de dos puntos', () {
      // Mismos valores inyectados y misma tolerancia que
      // calib/measurement_model.py::test_two_point_calibration
      const double gananciaInyectada = 1.05;
      const double offsetInyectado = 0.15;
      const InstrumentRange rango = InstrumentRange(
        etiqueta: '20 V',
        magnitud: Magnitud.voltajeDc,
        valorMaximo: 1000,
        ruidoSigma: 0.008,
        resolucionDecimales: 2,
      );
      final InstrumentModel instrumento = InstrumentModel(
        nombre: 'dos_puntos',
        rango: rango,
        ganancia: gananciaInyectada,
        offset: offsetInyectado,
        generador: NoiseGenerator(seed: 7),
      );

      const double patronBajo = 2.0;
      const double patronAlto = 18.0;
      const int n = 400;

      final List<double> bajas = List.generate(n, (_) => instrumento.medir(patronBajo).valor);
      final List<double> altas = List.generate(n, (_) => instrumento.medir(patronAlto).valor);

      final CalibracionEstimada estimada = CalibrationEngine.calibrarDosPuntos(
        patronBajo: patronBajo,
        promedioLecturaBaja: CalibrationEngine.promedio(bajas),
        patronAlto: patronAlto,
        promedioLecturaAlta: CalibrationEngine.promedio(altas),
      );

      expect(estimada.ganancia, closeTo(gananciaInyectada, 0.01));
      expect(estimada.offset, closeTo(offsetInyectado, 0.02));
      expect(estimada.dentroDeTolerancia(), isFalse);
    });

    test('instrumento bien calibrado queda dentro de tolerancia', () {
      const InstrumentRange rango = InstrumentRange(
        etiqueta: '20 V',
        magnitud: Magnitud.voltajeDc,
        valorMaximo: 1000,
        ruidoSigma: 0.008,
        resolucionDecimales: 2,
      );
      final InstrumentModel instrumento = InstrumentModel(
        nombre: 'bien_calibrado',
        rango: rango,
        generador: NoiseGenerator(seed: 3),
      );
      const double patronBajo = 2.0;
      const double patronAlto = 18.0;
      final List<double> bajas = List.generate(200, (_) => instrumento.medir(patronBajo).valor);
      final List<double> altas = List.generate(200, (_) => instrumento.medir(patronAlto).valor);

      final CalibracionEstimada estimada = CalibrationEngine.calibrarDosPuntos(
        patronBajo: patronBajo,
        promedioLecturaBaja: CalibrationEngine.promedio(bajas),
        patronAlto: patronAlto,
        promedioLecturaAlta: CalibrationEngine.promedio(altas),
      );

      expect(estimada.dentroDeTolerancia(), isTrue);
    });
  });
}
