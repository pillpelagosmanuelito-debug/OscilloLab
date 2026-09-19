/// Ficha tecnica de un instrumento o sensor, con la informacion pedagogica
/// que el encargo exige para cada componente del laboratorio:
/// funcionamiento, caracteristicas, aplicaciones y errores comunes.
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

/// Catalogo fijo de instrumentos del laboratorio (Modulo 1).
const List<FichaInstrumento> catalogoInstrumentos = [
  FichaInstrumento(
    id: 'multimetro',
    nombre: 'Multimetro digital',
    categoria: 'Instrumento de medicion general',
    funcionamiento: 'Convierte la magnitud de entrada (voltaje, corriente o '
        'resistencia) en una senal digital mediante un conversor '
        'analogico-digital y la muestra como un numero en pantalla. Cada '
        'funcion (V, A, Ω) usa un circuito de acondicionamiento distinto '
        'internamente, aunque el usuario solo vea un selector.',
    caracteristicas: [
      'Multiples rangos por funcion (autorrango o manual)',
      'Resolucion tipica de 3½ a 4½ digitos',
      'Impedancia de entrada alta (~10 MΩ) en modo voltaje',
      'Requiere romper el circuito para medir corriente en serie',
    ],
    aplicaciones: [
      'Verificar continuidad y voltajes de alimentacion',
      'Diagnostico de fallas en circuitos de control',
      'Medicion de resistencia de componentes fuera de circuito',
    ],
    erroresComunes: [
      'Medir corriente en modo voltaje (cortocircuito, riesgo de dano)',
      'Ignorar el signo de "OL" y forzar una escala insuficiente',
      'No considerar la resistencia interna del instrumento en circuitos de alta impedancia',
    ],
  ),
  FichaInstrumento(
    id: 'osciloscopio',
    nombre: 'Osciloscopio digital',
    categoria: 'Instrumento de medicion en el dominio del tiempo',
    funcionamiento: 'Muestrea la senal de entrada a intervalos regulares '
        '(frecuencia de muestreo) y reconstruye su forma de onda en una '
        'pantalla con eje vertical (voltaje, V/div) y horizontal (tiempo, '
        's/div). Un circuito de disparo (trigger) estabiliza la imagen '
        'sincronizando el inicio de cada barrido con un evento de la senal.',
    caracteristicas: [
      'Ancho de banda y frecuencia de muestreo limitan la senal maxima observable',
      'Escalas independientes vertical (V/div) y horizontal (tiempo/div)',
      'Trigger por nivel y pendiente para estabilizar senales periodicas',
      'Puede medir amplitud, periodo, frecuencia y fase entre canales',
    ],
    aplicaciones: [
      'Verificar forma de onda de fuentes de conmutacion',
      'Medir frecuencia y duty cycle de senales PWM en control',
      'Detectar ruido, rebote o distorsion que un multimetro no muestra',
    ],
    erroresComunes: [
      'Aliasing: muestrear a menos del doble de la frecuencia de la senal (Nyquist)',
      'Escala de tiempo/voltaje mal elegida (senal recortada o ilegible)',
      'Olvidar el factor de atenuacion de la punta (x1 / x10)',
    ],
  ),
  FichaInstrumento(
    id: 'sensor_temperatura',
    nombre: 'Sensor de temperatura (analogico)',
    categoria: 'Sensor / transductor',
    funcionamiento: 'Transforma la temperatura en una senal electrica '
        '(voltaje o resistencia) mediante una relacion fisica conocida '
        '(p. ej. 10 mV/°C en un sensor tipo LM35). Esa senal se lee con '
        'un multimetro o un conversor A/D, y luego se convierte de vuelta '
        'a temperatura aplicando la funcion de transferencia inversa.',
    caracteristicas: [
      'Funcion de transferencia lineal o casi lineal en su rango de trabajo',
      'Requiere acondicionamiento de senal (amplificacion/filtrado) en entornos ruidosos',
      'Tiempo de respuesta (constante termica) limita la velocidad de cambio detectable',
    ],
    aplicaciones: [
      'Monitoreo de temperatura de proceso industrial',
      'Control de temperatura en lazos cerrados (PID)',
      'Proteccion termica de motores y transformadores',
    ],
    erroresComunes: [
      'Confundir la senal del sensor con la temperatura real sin aplicar la funcion de transferencia',
      'No considerar el autocalentamiento del sensor por su propia corriente de excitacion',
      'Ubicacion fisica que no representa la temperatura real del proceso',
    ],
  ),
  FichaInstrumento(
    id: 'sensor_ultrasonico',
    nombre: 'Sensor ultrasonico de distancia',
    categoria: 'Sensor / transductor',
    funcionamiento: 'Emite un pulso ultrasonico y mide el tiempo que tarda '
        'en volver reflejado por un objeto (eco). La distancia se calcula '
        'como distancia = (velocidad_del_sonido * tiempo_de_vuelo) / 2.',
    caracteristicas: [
      'Depende de la velocidad del sonido en el medio (afectada por temperatura)',
      'Tiene un cono de deteccion; superficies no perpendiculares dispersan el eco',
      'Rango minimo de deteccion (zona ciega) cerca del sensor',
    ],
    aplicaciones: [
      'Deteccion de nivel de tanques',
      'Sensores anticolision en automatizacion movil',
      'Control de posicion en bandas transportadoras',
    ],
    erroresComunes: [
      'No corregir por temperatura ambiente, que cambia la velocidad del sonido',
      'Superficies blandas o angulos oblicuos que absorben o desvian el eco',
      'Interpretar ausencia de eco como "distancia cero" en vez de "sin lectura"',
    ],
  ),
];
