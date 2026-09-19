import 'package:flutter/material.dart';

import '../model/instrument_catalog.dart';

class InstrumentoDetalleScreen extends StatelessWidget {
  const InstrumentoDetalleScreen({super.key, required this.ficha});

  final FichaInstrumento ficha;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(ficha.nombre)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(ficha.categoria,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: Theme.of(context).colorScheme.secondary)),
          const SizedBox(height: 12),
          _Seccion(titulo: 'Funcionamiento', cuerpo: ficha.funcionamiento),
          _SeccionLista(titulo: 'Caracteristicas', items: ficha.caracteristicas),
          _SeccionLista(titulo: 'Aplicaciones', items: ficha.aplicaciones),
          _SeccionLista(
            titulo: 'Errores comunes',
            items: ficha.erroresComunes,
            icono: Icons.warning_amber_rounded,
            colorIcono: Theme.of(context).colorScheme.error,
          ),
        ],
      ),
    );
  }
}

class _Seccion extends StatelessWidget {
  const _Seccion({required this.titulo, required this.cuerpo});
  final String titulo;
  final String cuerpo;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(cuerpo, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _SeccionLista extends StatelessWidget {
  const _SeccionLista({
    required this.titulo,
    required this.items,
    this.icono = Icons.check_circle_outline,
    this.colorIcono,
  });

  final String titulo;
  final List<String> items;
  final IconData icono;
  final Color? colorIcono;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...items.map(
              (String texto) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(icono, size: 18, color: colorIcono),
                    const SizedBox(width: 8),
                    Expanded(child: Text(texto)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
