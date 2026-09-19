# Guía de Calibración del Motor de Medición

## Por qué se calibra un motor "de mentira"

Si el laboratorio virtual solo mostrara el valor real de una magnitud, no habría nada que interpretar: cualquier ejercicio de "lectura de instrumento" sería trivial. El valor educativo de OscilloLab depende de que el motor de medición se comporte **estadísticamente** como un instrumento real: con error sistemático, ruido aleatorio y resolución finita coherentes entre sí. Por eso el modelo se diseñó y probó en Python (`calib/measurement_model.py`) antes de escribirse en Dart (`lib/core/measurement/`), como un motor calibrado, no una decisión estética.

## El modelo

```
lectura_display = round( valor_real * ganancia + offset + ruido , resolución )
```

- **ganancia/offset:** error sistemático. `ganancia=1.0, offset=0.0` = instrumento bien calibrado.
- **ruido:** gaussiano N(0, σ²), σ propio de cada rango/escala.
- **resolución:** número de decimales que ese rango puede mostrar.
- **overload:** si `|valor_real| > rango_máximo`, el instrumento reporta "OL", no un número.

## Incertidumbre declarada

```
U = 2σ + medio_dígito_de_resolución      (regla de instrumentación: cobertura ≥95%, k=2)
```

Es deliberadamente conservadora: no busca exactamente 95.45% (el 2σ teórico de una gaussiana pura), sino garantizar **al menos** 95% incluso con el margen adicional del redondeo de pantalla.

## Pruebas de calibración y resultado

| Prueba | Qué verifica | Resultado obtenido |
|---|---|---|
| Cobertura DCV (20 V, σ=0.008) | ≥95% de 20 000 lecturas caen dentro de ±U del valor real | 99.8% |
| Cobertura Ω (2 kΩ, σ=0.9) | Igual, para resistencia | 96.1% |
| Cobertura Vpp osciloscopio (σ=0.05) | Igual, para amplitud pico-pico | 96.3% |
| Overload | `medir(25.0)` con rango máx. 20 V devuelve `None` (OL) | Correcto |
| Recuperación de calibración de 2 puntos | Con ganancia inyectada 1.05 y offset 0.15, la regresión de 2 puntos (patrones 2 y 18) recupera ambos valores | ganancia estimada 1.04999..., offset estimado 0.15035... |

Ejecutar: `python3 calib/measurement_model.py` → imprime el JSON de resultados y `TODAS LAS PRUEBAS DE CALIBRACION PASARON.`

## Porting a Dart: qué se preservó exactamente

| Concepto Python | Equivalente Dart | Archivo |
|---|---|---|
| `gaussian_noise(sigma)` | `NoiseGenerator.gaussian(sigma)` | `lib/core/measurement/noise_generator.dart` |
| `Instrument.measure()` | `InstrumentModel.medir()` | `lib/core/measurement/instrument_model.dart` |
| `declared_uncertainty()` | `InstrumentRange.incertidumbreDeclarada` | `lib/core/measurement/instrument_range.dart` |
| `test_two_point_calibration()` | `CalibrationEngine.calibrarDosPuntos()` | `lib/core/measurement/calibration_engine.dart` |

Las pruebas Dart en `test/core/measurement/` reproducen los mismos escenarios (misma ganancia/offset inyectados, misma tolerancia) para que la migración quede verificada también del lado de Flutter una vez el proyecto se compile (ver limitación de entorno en `docs/03_Arquitectura_Tecnica.md`).

## Extender el motor (guía para quien continúe el proyecto)

Para agregar un instrumento nuevo: definir un `InstrumentRange` con `ruidoSigma` y `resolucionDecimales` calibrados (repetir el procedimiento de este documento con datos reales del instrumento que se quiere simular, no valores arbitrarios), y opcionalmente `ganancia`/`offset` si el ejercicio requiere que el instrumento esté descalibrado a propósito.
