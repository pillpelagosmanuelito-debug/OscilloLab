import '../../../core/measurement/instrument_range.dart';
import '../../../core/measurement/units.dart';

/// Caso industrial del Módulo 5: combina selección de instrumento,
/// medición e interpretación en un escenario de instrumentación,
/// control o automatización, tal como lo exige el encargo.
class CasoIndustrial {
  const CasoIndustrial({
    required this.id,
    required this.contexto,
    required this.opcionesInstrumento,
    required this.instrumentoCorrectoId,
    required this.justificacionInstrumento,
    required this.valorReal,
    required this.rango,
    required this.umbralAccion,
    required this.alertaSiMayorQueUmbral,
    required this.opcionesAccion,
    required this.accionCorrectaId,
    required this.justificacionAccion,
  });

  final String id;
  final String contexto;

  final List<MapEntry<String, String>> opcionesInstrumento; // id -> etiqueta
  final String instrumentoCorrectoId;
  final String justificacionInstrumento;

  final double valorReal;
  final InstrumentRange rango;

  /// Umbral que separa "acción normal" de "acción de alerta", evaluado
  /// sobre la LECTURA del instrumento (no sobre valorReal directamente),
  /// para que el estudiante decida en base a lo que el instrumento
  /// realmente reportó.
  final double umbralAccion;

  /// true: se activa la alerta cuando la LECTURA supera el umbral (p. ej.
  /// temperatura, rizado). false: se activa cuando la lectura es MENOR
  /// que el umbral (p. ej. distancia al líquido: más cerca = más lleno).
  final bool alertaSiMayorQueUmbral;
  final List<MapEntry<String, String>> opcionesAccion;
  final String accionCorrectaId;
  final String justificacionAccion;

  bool debeAlertar(double lectura) {
    return alertaSiMayorQueUmbral
        ? lectura > umbralAccion
        : lectura < umbralAccion;
  }
}

const List<CasoIndustrial> casosIndustriales = [
  CasoIndustrial(
    id: 'sobretemperatura_motor',
    contexto: 'Un motor de una banda transportadora lleva 3 horas en '
        'operación continua. El protocolo exige verificar su temperatura '
        'de carcasa antes de autorizar otra hora de trabajo.',
    opcionesInstrumento: [
      MapEntry('sensor_temperatura', 'Sensor de temperatura'),
      MapEntry('osciloscopio', 'Osciloscopio'),
      MapEntry('multimetro', 'Multímetro (solo voltaje)'),
    ],
    instrumentoCorrectoId: 'sensor_temperatura',
    justificacionInstrumento: 'Se necesita una medición directa de '
        'temperatura; un osciloscopio o un multímetro en voltaje no miden '
        'esa magnitud sin un sensor intermedio.',
    valorReal: 92.0,
    rango: InstrumentRange(
        etiqueta: '150 °C',
        magnitud: Magnitud.temperatura,
        valorMaximo: 150,
        ruidoSigma: 0.4,
        resolucionDecimales: 1),
    umbralAccion: 85.0,
    alertaSiMayorQueUmbral: true,
    opcionesAccion: [
      MapEntry('continuar', 'Autorizar otra hora de operación sin cambios'),
      MapEntry(
          'detener', 'Detener el motor y dejarlo enfriar antes de continuar'),
      MapEntry('ignorar', 'Ignorar la lectura, es solo una fluctuación'),
    ],
    accionCorrectaId: 'detener',
    justificacionAccion: 'Por encima del umbral de 85°C el motor entra en '
        'zona de riesgo térmico: la acción correcta es detenerlo, no '
        'continuar ni ignorar la lectura.',
  ),
  CasoIndustrial(
    id: 'ripple_fuente_switching',
    contexto: 'Una fuente de conmutación (switching) alimenta un PLC. Se '
        'reportan reinicios intermitentes del PLC y se sospecha de rizado '
        'excesivo en la salida DC.',
    opcionesInstrumento: [
      MapEntry('osciloscopio', 'Osciloscopio'),
      MapEntry('multimetro', 'Multímetro en DC'),
      MapEntry('sensor_ultrasonico', 'Sensor ultrasónico'),
    ],
    instrumentoCorrectoId: 'osciloscopio',
    justificacionInstrumento: 'El multímetro en DC promedia y puede '
        'ocultar el rizado de alta frecuencia; solo el osciloscopio '
        'muestra la componente AC superpuesta en el tiempo.',
    valorReal: 0.62,
    rango: InstrumentRange(
        etiqueta: '1 Vpp',
        magnitud: Magnitud.amplitudPicoPico,
        valorMaximo: 1,
        ruidoSigma: 0.006,
        resolucionDecimales: 3),
    umbralAccion: 0.3,
    alertaSiMayorQueUmbral: true,
    opcionesAccion: [
      MapEntry('continuar', 'Rizado normal, no requiere acción'),
      MapEntry('revisar_filtro',
          'Revisar/reemplazar el capacitor de filtro de salida'),
      MapEntry('cambiar_plc', 'Cambiar el PLC, el problema es del controlador'),
    ],
    accionCorrectaId: 'revisar_filtro',
    justificacionAccion: 'Un rizado por encima de 0.3 Vpp en una fuente '
        'que debería ser DC limpia indica falla de filtrado, típicamente '
        'un capacitor de salida degradado, no una falla del PLC.',
  ),
  CasoIndustrial(
    id: 'nivel_tanque_automatizacion',
    contexto: 'Un sistema de automatización debe detener el llenado de un '
        'tanque cuando el nivel de líquido se acerca a la boca superior.',
    opcionesInstrumento: [
      MapEntry('sensor_ultrasonico', 'Sensor ultrasónico'),
      MapEntry('multimetro', 'Multímetro'),
      MapEntry('sensor_temperatura', 'Sensor de temperatura'),
    ],
    instrumentoCorrectoId: 'sensor_ultrasonico',
    justificacionInstrumento: 'Se necesita distancia sin contacto entre el '
        'sensor y la superficie del líquido; eso es exactamente lo que '
        'entrega un sensor ultrasónico.',
    valorReal: 4.5,
    rango: InstrumentRange(
        etiqueta: '50 cm',
        magnitud: Magnitud.distancia,
        valorMaximo: 50,
        ruidoSigma: 0.15,
        resolucionDecimales: 1),
    umbralAccion: 6.0,
    alertaSiMayorQueUmbral: false,
    opcionesAccion: [
      MapEntry('continuar', 'Continuar llenando, hay espacio suficiente'),
      MapEntry('detener_llenado', 'Detener el llenado de inmediato'),
      MapEntry('vaciar', 'Vaciar el tanque por completo'),
    ],
    accionCorrectaId: 'detener_llenado',
    justificacionAccion: 'La distancia leída es MENOR que el umbral de '
        '6 cm (más cerca de la boca del tanque = más lleno): el sistema '
        'debe detener el llenado para evitar derrame.',
  ),
];
