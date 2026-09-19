# Manual de Usuario — OscilloLab

## Navegación general

La app usa una barra inferior con 3 destinos:

- **Inicio:** lista de los 5 módulos con tu progreso en cada uno.
- **Progreso:** resumen numérico de ejercicios completados por módulo.
- **Asistente:** panel de consulta rápida ("¿qué instrumento usarías?").

## Módulo 1 · Instrumentos

Toca cualquier instrumento para ver su ficha: funcionamiento, características, aplicaciones y errores comunes. El botón **"Ejercicio: ¿qué instrumento usarías?"** presenta 5 escenarios; elige el instrumento correcto y lee la explicación antes de continuar.

## Módulo 2 · Mediciones

Elige **Laboratorio de multímetro** o **Laboratorio de osciloscopio**.

- **Multímetro:** elige un escenario, elige el rango/escala (chips), presiona **Medir**. El display muestra el valor con su incertidumbre (± , k=2) o "OL" si el rango es insuficiente. El asistente comenta si tu elección de rango fue razonable.
- **Osciloscopio:** elige un escenario, observa la forma de onda en la pantalla verde, y presiona **Medir** en cada tarjeta (Amplitud, Frecuencia) para obtener la lectura simulada.

## Módulo 3 · Errores

**Clasificación:** por cada caso, presiona **"Tomar 1 lectura y promedio de 30 lecturas"**, compara ambos valores y decide si el error dominante es **Sistemático** o **Aleatorio**. El asistente explica la respuesta correcta.

**Propagación** (icono Σ en la barra superior): se te dan un voltaje y una corriente medidos, cada uno con su incertidumbre. Calcula la potencia `P = V·I` y su incertidumbre combinada `U(P)` (regla: las incertidumbres *relativas* se combinan en cuadratura para un producto) e ingresa ambos valores para verificar.

## Módulo 4 · Calibración

Elige un instrumento a calibrar. Presiona **"Medir ambos patrones y calibrar"**: la app toma 25 lecturas en el patrón bajo y 25 en el patrón alto, promedia, y estima la ganancia y el offset reales del instrumento (calibración de dos puntos). El asistente indica si el instrumento queda dentro de tolerancia o si necesita ajuste, y de qué tipo (ganancia u offset).

## Módulo 5 · Casos industriales

Cada caso tiene 3 pasos:

1. **Selecciona el instrumento** adecuado para el escenario descrito.
2. **Mide** con ese instrumento.
3. **Decide la acción** correcta según la lectura obtenida (no según lo que "sabes" que debería ser).

Al final de los 3 casos se muestra tu puntaje total (selección de instrumento + decisión de acción).

## Progreso

Tu progreso se guarda automáticamente en el dispositivo (no requiere cuenta ni conexión a internet) y persiste entre sesiones.
