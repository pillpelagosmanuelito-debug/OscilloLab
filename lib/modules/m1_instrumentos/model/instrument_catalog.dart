/// Ficha técnica de un instrumento o sensor, con la información pedagógica
/// que el encargo exige para cada componente del laboratorio:
/// funcionamiento, características, aplicaciones y errores comunes.
class FichaInstrumento {
  const FichaInstrumento({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.funcionamiento,
    required this.caracteristicas,
    required this.aplicaciones,
    required this.erroresComunes,
  });

  final String id;
  final String nombre;
  final String categoria;
  final String funcionamiento;
  final List<String> caracteristicas;
  final List<String> aplicaciones;
  final List<String> erroresComunes;
}

/// Catálogo fijo de instrumentos del laboratorio (Módulo 1).
const List<FichaInstrumento> catalogoInstrumentos = [
  FichaInstrumento(
    id: 'multimetro',
    nombre: 'Multímetro digital',
    categoria: 'Instrumento de medición general',
    funcionamiento: 'Convierte la magnitud de entrada (voltaje, corriente o '
        'resistencia) en una señal digital mediante un conversor '
        'analógico-digital y la muestra como un número en pantalla. Cada '
        'función (V, A, Ω) usa un circuito de acondicionamiento distinto '
        'internamente, aunque el usuario solo vea un selector.',
    caracteristicas: [
      'Múltiples rangos por función (autorrango o manual)',
      'Resolución típica de 3½ a 4½ dígitos',
      'Impedancia de entrada alta (~10 MΩ) en modo voltaje',
      'Requiere romper el circuito para medir corriente en serie',
    ],
    aplicaciones: [
      'Verificar continuidad y voltajes de alimentación',
      'Diagnóstico de fallas en circuitos de control',
      'Medición de resistencia de componentes fuera de circuito',
    ],
    erroresComunes: [
      'Medir corriente en modo voltaje (cortocircuito, riesgo de daño)',
      'Ignorar el signo de "OL" y forzar una escala insuficiente',
      'No considerar la resistencia interna del instrumento en circuitos de alta impedancia',
    ],
  ),
  FichaInstrumento(
    id: 'osciloscopio',
    nombre: 'Osciloscopio digital',
    categoria: 'Instrumento de medición en el dominio del tiempo',
    funcionamiento: 'Muestrea la señal de entrada a intervalos regulares '
        '(frecuencia de muestreo) y reconstruye su forma de onda en una '
        'pantalla con eje vertical (voltaje, V/div) y horizontal (tiempo, '
        's/div). Un circuito de disparo (trigger) estabiliza la imagen '
        'sincronizando el inicio de cada barrido con un evento de la señal.',
    caracteristicas: [
      'Ancho de banda y frecuencia de muestreo limitan la señal máxima observable',
      'Escalas independientes vertical (V/div) y horizontal (tiempo/div)',
      'Trigger por nivel y pendiente para estabilizar señales periódicas',
      'Puede medir amplitud, período, frecuencia y fase entre canales',
    ],
    aplicaciones: [
      'Verificar forma de onda de fuentes de conmutación',
      'Medir frecuencia y duty cycle de señales PWM en control',
      'Detectar ruido, rebote o distorsión que un multímetro no muestra',
    ],
    erroresComunes: [
      'Aliasing: muestrear a menos del doble de la frecuencia de la señal (Nyquist)',
      'Escala de tiempo/voltaje mal elegida (señal recortada o ilegible)',
      'Olvidar el factor de atenuación de la punta (x1 / x10)',
    ],
  ),
  FichaInstrumento(
    id: 'sensor_temperatura',
    nombre: 'Sensor de temperatura (analógico)',
    categoria: 'Sensor / transductor',
    funcionamiento: 'Transforma la temperatura en una señal eléctrica '
        '(voltaje o resistencia) mediante una relación física conocida '
        '(p. ej. 10 mV/°C en un sensor tipo LM35). Esa señal se lee con '
        'un multímetro o un conversor A/D, y luego se convierte de vuelta '
        'a temperatura aplicando la función de transferencia inversa.',
    caracteristicas: [
      'Función de transferencia lineal o casi lineal en su rango de trabajo',
      'Requiere acondicionamiento de señal (amplificación/filtrado) en entornos ruidosos',
      'Tiempo de respuesta (constante térmica) limita la velocidad de cambio detectable',
    ],
    aplicaciones: [
      'Monitoreo de temperatura de proceso industrial',
      'Control de temperatura en lazos cerrados (PID)',
      'Protección térmica de motores y transformadores',
    ],
    erroresComunes: [
      'Confundir la señal del sensor con la temperatura real sin aplicar la función de transferencia',
      'No considerar el autocalentamiento del sensor por su propia corriente de excitación',
      'Ubicación física que no representa la temperatura real del proceso',
    ],
  ),
  FichaInstrumento(
    id: 'sensor_ultrasonico',
    nombre: 'Sensor ultrasónico de distancia',
    categoria: 'Sensor / transductor',
    funcionamiento: 'Emite un pulso ultrasónico y mide el tiempo que tarda '
        'en volver reflejado por un objeto (eco). La distancia se calcula '
        'como distancia = (velocidad_del_sonido * tiempo_de_vuelo) / 2.',
    caracteristicas: [
      'Depende de la velocidad del sonido en el medio (afectada por temperatura)',
      'Tiene un cono de detección; superficies no perpendiculares dispersan el eco',
      'Rango mínimo de detección (zona ciega) cerca del sensor',
    ],
    aplicaciones: [
      'Detección de nivel de tanques',
      'Sensores anticolisión en automatización móvil',
      'Control de posición en bandas transportadoras',
    ],
    erroresComunes: [
      'No corregir por temperatura ambiente, que cambia la velocidad del sonido',
      'Superficies blandas o ángulos oblicuos que absorben o desvían el eco',
      'Interpretar ausencia de eco como "distancia cero" en vez de "sin lectura"',
    ],
  ),
];
