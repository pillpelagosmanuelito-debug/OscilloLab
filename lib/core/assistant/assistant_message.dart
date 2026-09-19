enum TipoMensajeAsistente { consejo, advertencia, error, exito }

class MensajeAsistente {
  const MensajeAsistente({required this.texto, required this.tipo});

  final String texto;
  final TipoMensajeAsistente tipo;
}
