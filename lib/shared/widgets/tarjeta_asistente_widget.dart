import 'package:flutter/material.dart';

import '../../core/assistant/assistant_message.dart';

/// Tarjeta reutilizable para mostrar la respuesta del asistente técnico
/// en cualquier módulo (Mediciones, Errores, Calibración, Casos).
class TarjetaAsistenteWidget extends StatelessWidget {
  const TarjetaAsistenteWidget({super.key, required this.mensaje});

  final MensajeAsistente mensaje;

  @override
  Widget build(BuildContext context) {
    final Color color = switch (mensaje.tipo) {
      TipoMensajeAsistente.exito => Colors.green,
      TipoMensajeAsistente.advertencia => Colors.orange,
      TipoMensajeAsistente.error => Colors.red,
      TipoMensajeAsistente.consejo => Colors.blueAccent,
    };
    return Card(
      color: color.withOpacity(0.12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.support_agent, color: color),
            const SizedBox(width: 10),
            Expanded(child: Text(mensaje.texto)),
          ],
        ),
      ),
    );
  }
}
