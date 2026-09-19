# Memoria Descriptiva — OscilloLab

## 1. Objetivo

Crear un laboratorio virtual para aprender medición electrónica e instrumentación, donde el estudiante practique con instrumentos simulados (multímetro, osciloscopio, sensores) que se comportan como instrumentos reales: con error, ruido, resolución finita y necesidad de calibración — no como un simple lector del "valor verdadero".

## 2. Problema educativo

Los estudiantes de Ingeniería Electrónica (líneas de Instrumentación, Control y Automatización) conocen los instrumentos de medición desde la teoría, pero llegan a laboratorio con poca práctica interpretando lo que un instrumento *realmente* reporta: no distinguen error sistemático de ruido aleatorio, no saben calcular ni propagar incertidumbre, y no han tenido que detectar por sí mismos que un instrumento está descalibrado.

## 3. Usuario objetivo

Estudiantes de Ingeniería Electrónica (y afines: Mecatrónica, Automatización) en cursos de Instrumentación, Control y Mediciones Eléctricas.

## 4. Competencias que desarrolla

| Competencia | Cómo se practica en la app |
|---|---|
| Medición | Elegir instrumento y rango correctos; leer un display con incertidumbre |
| Calibración | Estimar ganancia/offset de un instrumento contra dos patrones de referencia |
| Interpretación de datos | Clasificar error sistemático vs. aleatorio; propagar incertidumbre; decidir acciones industriales según una lectura |

## 5. Experiencia de aprendizaje

El estudiante entra a un laboratorio con multímetro, osciloscopio y sensores simulados. Cada módulo aumenta el nivel de abstracción: primero conoce los instrumentos (Módulo 1), luego los usa para medir (Módulo 2), luego entiende por qué sus mediciones tienen error (Módulo 3), luego aprende a corregir ese error (Módulo 4), y finalmente aplica todo en casos de una planta industrial real (Módulo 5).

## 6. MVP

**Incluye:** catálogo de instrumentos básicos (multímetro, osciloscopio, 2 sensores), mediciones simuladas con motor de error calibrado, ejercicios de clasificación y propagación de error, calibración de dos puntos, 3 casos industriales, asistente técnico por reglas, progreso persistente local.

**No incluye (fuera de alcance deliberado del MVP):** reconocimiento visual de componentes o circuitos, conectividad con hardware real (SCPI/USB), multiusuario o backend en la nube, generación de ejercicios por IA generativa.

## 7. IA: por qué un asistente por reglas y no un LLM

Se evaluó explícitamente incorporar un asistente con IA generativa (ver `anthropic-skills:ai-integration-specialist`) y se descartó para el MVP por tres razones:

1. **El dominio es cerrado y determinista.** "¿Por qué mi multímetro muestra OL?" o "¿es error sistemático o aleatorio?" tienen una respuesta técnica correcta y verificable; una tabla de reglas la da sin riesgo de alucinación y de forma instantánea.
2. **Restricción de diseño no negociable.** El asistente nunca debe ver el valor real oculto de una magnitud (ver `docs/03_Arquitectura_Tecnica.md`); un sistema de reglas puede garantizar esto por construcción, un LLM sobre un prompt es más difícil de auditar en ese sentido.
3. **Costo/latencia/dependencia externa.** Un sistema de reglas no requiere llamadas a un servicio externo, funciona sin conexión y es gratuito en tiempo de ejecución.

Esto no descarta IA generativa a futuro: una evolución razonable (fuera del MVP) sería un tutor conversacional que *envuelva* estas mismas reglas para responder preguntas abiertas del estudiante, siempre restringido a no recibir el valor real como contexto.

## 8. Diferenciación frente al catálogo existente

OscilloLab es la primera app del catálogo centrada en medición/calibración/interpretación de datos como competencia principal. CircuitLab Academy resuelve circuitos y CircuitAR selecciona componentes; ninguna enseña a leer un instrumento real e interpretar su incertidumbre. Ver el análisis de diferenciación completo en la conversación de encargo de este proyecto (comparación módulo por módulo contra CircuitAR).

## 9. Riesgos y debilidades identificadas (análisis crítico)

| Riesgo | Mitigación aplicada | Pendiente / limitación conocida |
|---|---|---|
| Que "simular un instrumento" se reduzca a mostrar el valor real con un decorado | Motor de error con ganancia+offset+ruido gaussiano+resolución finita, calibrado y validado estadísticamente (`calib/measurement_model.py`) | El ruido es gaussiano puro; instrumentos reales también tienen no-linealidades y deriva térmica no modeladas en el MVP |
| Asistente que "haga trampa" leyendo el valor real | Todas las funciones de `AssistantEngine` reciben solo resultados ya medidos, nunca `valorReal` | No hay un test automatizado que verifique estáticamente que ningún caller futuro rompa esta regla; queda como control de code review |
| Ejercicios de calibración con soluciones fáciles de memorizar tras 1–2 intentos | 3 casos con relaciones ganancia/offset distintas | Solo 3–4 casos por módulo; para uso en curso real convendría un generador aleatorio de casos dentro de rangos pedagógicamente válidos |
| No se pudo compilar ni ejecutar `flutter test`/`flutter build` en este entorno de desarrollo (SDK de Flutter no descargable por política de red) | Motor de medición validado independientemente en Python antes de portar a Dart; código revisado manualmente con `dart format`/`analyze` como referencia | **Riesgo real:** puede haber errores de compilación no detectados; el primer `flutter pub get && flutter analyze && flutter test` del desarrollador es la verificación pendiente antes de considerar el build "cerrado" |

## 10. Potencial de uso real

Aplicable directamente en cursos de Instrumentación Electrónica y Mediciones Eléctricas como complemento de laboratorio físico, especialmente para practicar antes de tener acceso al equipo real o para repetir ejercicios de interpretación sin consumir tiempo de laboratorio.
