# OscilloLab

Laboratorio virtual de instrumentación y medición electrónica para estudiantes de Ingeniería Electrónica (Instrumentación, Control, Automatización).

## Problema educativo

Los estudiantes conocen los instrumentos de medición teóricamente (multímetro, osciloscopio, sensores) pero tienen poca práctica real interpretando lo que esos instrumentos muestran: error sistemático vs. aleatorio, incertidumbre, calibración y decisiones basadas en una lectura, no en el valor "verdadero" (que en la vida real nunca se conoce).

## Los 5 módulos

| # | Módulo | Qué practica el estudiante |
|---|--------|------------------------------|
| 1 | Instrumentos | Fichas técnicas + selección del instrumento correcto por escenario |
| 2 | Mediciones | Laboratorio interactivo: multímetro y osciloscopio con error/incertidumbre reales |
| 3 | Errores | Clasificar error sistemático vs. aleatorio; propagación de incertidumbre (regla GUM) |
| 4 | Calibración | Detectar y corregir descalibración (ganancia/offset) con dos patrones de referencia |
| 5 | Casos industriales | Seleccionar instrumento, medir e interpretar en escenarios de control/automatización |

## Motor de medición

El núcleo de la app (`lib/core/measurement/`) simula instrumentos con error sistemático (ganancia + offset), ruido gaussiano y resolución de pantalla finita — no un simple despliegue del valor real. Este modelo se calibró y validó estadísticamente en Python antes de portarse a Dart: ver `calib/measurement_model.py` y `docs/04_Guia_Calibracion_Motor.md`.

## Stack técnico

- Flutter 3.24 (Dart >=3.3), arquitectura MVVM
- Riverpod (`Notifier`/`NotifierProvider`) para estado
- `shared_preferences` para progreso persistente
- CI/CD con GitHub Actions → APK de release (ver `.github/workflows/ci.yml`)

## Estructura del proyecto

```
lib/
  core/measurement/    Motor de medición (instrumento, ruido, calibración, propagación)
  core/assistant/       Asistente técnico por reglas (sin IA generativa)
  modules/m1..m5/        Un módulo por carpeta: model / viewmodel / view
  modules/home/          Cascarón de navegación (bottom bar: Inicio/Progreso/Asistente)
  shared/                Estado compartido (progreso) y widgets reutilizables
  theme/                 Tema visual "panel de instrumento"
calib/                   Script Python de calibración estadística del motor (no es parte de la app)
test/                    Pruebas unitarias del motor y del asistente + smoke test de la app
docs/                    Memoria descriptiva, manual de usuario, arquitectura, guía de calibración
```

## Cómo compilar

```bash
flutter create --platforms=android,ios --org com.oscillolab.app --project-name oscillolab .
flutter pub get
dart run flutter_launcher_icons
flutter test
flutter build apk --release
```

> Nota de entrega: este proyecto se construyó en un entorno sin el SDK de Flutter instalable (la descarga del motor de Dart está bloqueada por política de red del contenedor). El código se escribió y revisó manualmente con `dart format`/`analyze` como referencia, pero **no se ejecutó `flutter test` ni `flutter build` en este entorno**. El primer `flutter pub get && flutter test` en tu máquina o en CI es la verificación real; el pipeline de GitHub Actions incluido lo hace automáticamente en cada push.
