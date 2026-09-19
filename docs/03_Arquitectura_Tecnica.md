# Arquitectura Técnica — OscilloLab

## Patrón: MVVM + Riverpod

- **Model:** clases inmutables de datos y catálogos (`lib/modules/*/model/`), y el motor de dominio compartido (`lib/core/measurement/`, `lib/core/assistant/`).
- **ViewModel:** un `Notifier<State>` por pantalla interactiva (`lib/modules/*/viewmodel/`), expuesto vía `NotifierProvider`. Contiene toda la lógica de negocio de la pantalla; la View solo lee estado y despacha acciones.
- **View:** widgets `ConsumerWidget`/`ConsumerStatefulWidget` (`lib/modules/*/view/`) sin lógica de negocio, solo composición visual y navegación.

## Por qué la estructura es distinta a las apps anteriores de la fábrica

CircuitLab Academy y CircuitAR organizan `lib/` por **capa técnica** (`core/`, `data/`, `domain/`, `presentation/`) con navegación por `Drawer`. OscilloLab organiza `lib/modules/` por **módulo pedagógico** (`m1_instrumentos/`, `m2_mediciones/`, ...), cada uno con su propio `model/viewmodel/view`, y navega con una barra inferior de 3 destinos (Inicio/Progreso/Asistente) en vez de un Drawer. Esto es deliberado (pedido explícito de diferenciación) y también resulta razonable aquí: cada módulo es prácticamente independiente (no comparten dominio de datos entre sí, solo el motor de medición y el asistente en `core/`), así que agrupar por módulo minimiza el salto entre carpetas al trabajar en uno.

## Núcleo de dominio (`lib/core/measurement/`)

| Archivo | Responsabilidad |
|---|---|
| `noise_generator.dart` | Ruido gaussiano (Box-Muller) para simular ruido electrónico/cuantización |
| `instrument_range.dart` | Un rango/escala: ruido, resolución, valor máximo, incertidumbre declarada |
| `instrument_model.dart` | `InstrumentModel.medir()`: aplica ganancia+offset+ruido+redondeo+overload |
| `calibration_engine.dart` | Calibración de dos puntos (regresión lineal) para estimar ganancia/offset reales |
| `error_propagation.dart` | Combinación de incertidumbres (regla GUM) y clasificación sistemático/aleatorio |

Este motor se diseñó y **validó estadísticamente en Python antes de escribirse en Dart** (ver `docs/04_Guia_Calibracion_Motor.md` y `calib/measurement_model.py`), para no depender de "se ve razonable" sino de propiedades estadísticas verificadas (cobertura de incertidumbre ≥95%, recuperación de parámetros inyectados dentro de tolerancia).

## Asistente técnico (`lib/core/assistant/assistant_engine.dart`)

Regla de diseño no negociable: **ninguna función de `AssistantEngine` recibe el valor real oculto de una magnitud.** Solo recibe lo mismo que el estudiante puede ver: `ResultadoMedicion` (lo que el instrumento mostró), el rango/instrumento elegido, o la respuesta que el estudiante ingresó. Es un sistema de reglas explícitas, no un modelo de lenguaje (justificación completa en `docs/01_Memoria_Descriptiva.md §7`).

## Estado y persistencia

- Estado de UI/dominio: Riverpod (`Notifier`), sin paquetes de state management adicionales.
- Progreso del estudiante: `shared_preferences` (`lib/shared/state/progress_provider.dart`), clave por módulo (`m1`..`m5`), sin backend.

## Por qué no hay backend ni multiusuario en el MVP

El objetivo del MVP es practicar interpretación de mediciones de forma individual y offline; un backend con perfiles y ranking no es necesario para esa competencia y añadiría superficie de mantenimiento (auth, base de datos, costos de hosting) sin valor educativo proporcional en esta primera versión. Es una extensión natural post-MVP si se quiere gamificación entre secciones de un curso.

## Limitación de este entorno de construcción

Este proyecto se escribió en un contenedor donde la descarga del SDK de Dart/Flutter está bloqueada por política de red (el `storage.googleapis.com` que sirve el motor de Dart no es alcanzable). Por lo tanto:

- El motor de medición se validó de forma independiente en Python (`calib/measurement_model.py`), y el porting a Dart se hizo línea por línea siguiendo la misma lógica ya probada.
- El código Dart de UI y navegación se escribió y revisó manualmente (imports, tipos, llaves) pero **no pasó por `flutter analyze` ni `flutter test` en este entorno**.
- El pipeline de CI (`.github/workflows/ci.yml`) ejecuta `flutter create .` (para generar `android/`/`ios/`, que no se incluyen en el repositorio), `flutter analyze`, `dart format --set-exit-if-changed` y `flutter test` en cada push — esa es la primera verificación real y automática del código.

**Recomendación antes de considerar el build cerrado:** ejecutar `flutter pub get && flutter analyze && flutter test` localmente o esperar el primer run de CI, y corregir cualquier error de compilación que aparezca (esperable en un proyecto de este tamaño escrito sin compilador disponible).
