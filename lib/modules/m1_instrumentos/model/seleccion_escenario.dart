/// Escenario del ejercicio "¿que instrumento usarias?" del Modulo 1.
class EscenarioSeleccion {
  const EscenarioSeleccion({
    required this.descripcion,
    required this.opciones,
    required this.idCorrectoId,
    required this.explicacion,
  });

  final String descripcion;
  final List<String> opciones;
  final String idCorrectoId;
  final String explicacion;
}

const List<EscenarioSeleccion> escenariosSeleccion = [
  EscenarioSeleccion(
    descripcion: 'Necesitas verificar si una fuente de 12V DC para un PLC '
        'entrega el voltaje correcto en un punto de prueba fijo.',
    opciones: ['multimetro', 'osciloscopio', 'sensor_temperatura'],
    idCorrectoId: 'multimetro',
    explicacion: 'Es un valor DC estable puntual: el multimetro da la '
        'resolucion necesaria sin la complejidad de un osciloscopio.',
  ),
  EscenarioSeleccion(
    descripcion: 'Quieres verificar si la senal PWM que controla un motor '
        'tiene el duty cycle y la frecuencia correctos.',
    opciones: ['multimetro', 'osciloscopio', 'sensor_ultrasonico'],
    idCorrectoId: 'osciloscopio',
    explicacion: 'Un multimetro solo da un promedio; necesitas ver la '
        'forma de onda completa en el tiempo para medir duty cycle y '
        'frecuencia con certeza.',
  ),
  EscenarioSeleccion(
    descripcion: 'Un horno industrial necesita mantener 180°C en un lazo '
        'de control automatico.',
    opciones: ['sensor_temperatura', 'osciloscopio', 'multimetro'],
    idCorrectoId: 'sensor_temperatura',
    explicacion: 'El lazo de control necesita una senal continua '
        'proporcional a temperatura; eso es lo que entrega un sensor de '
        'temperatura, no un instrumento de medicion manual.',
  ),
  EscenarioSeleccion(
    descripcion: 'Una banda transportadora debe detener un objeto cuando '
        'esta a 5 cm del sensor, sin contacto fisico.',
    opciones: ['sensor_ultrasonico', 'multimetro', 'sensor_temperatura'],
    idCorrectoId: 'sensor_ultrasonico',
    explicacion: 'Deteccion de distancia sin contacto es exactamente el '
        'caso de uso de un sensor ultrasonico (o infrarrojo).',
  ),
  EscenarioSeleccion(
    descripcion: 'Sospechas que una fuente supuestamente DC tiene rizado '
        '(ripple) de alta frecuencia superpuesto.',
    opciones: ['osciloscopio', 'multimetro', 'sensor_ultrasonico'],
    idCorrectoId: 'osciloscopio',
    explicacion: 'Un multimetro en DC promedia y puede ocultar el rizado; '
        'el osciloscopio muestra la componente AC superpuesta en el tiempo.',
  ),
];
