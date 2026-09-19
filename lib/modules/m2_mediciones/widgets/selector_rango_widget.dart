import 'package:flutter/material.dart';

import '../../../core/measurement/instrument_range.dart';

class SelectorRangoWidget extends StatelessWidget {
  const SelectorRangoWidget({
    super.key,
    required this.rangos,
    required this.seleccionado,
    required this.onSeleccionar,
  });

  final List<InstrumentRange> rangos;
  final InstrumentRange seleccionado;
  final ValueChanged<InstrumentRange> onSeleccionar;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: rangos.map((rango) {
        final bool activo = rango.etiqueta == seleccionado.etiqueta;
        return ChoiceChip(
          label: Text(rango.etiqueta),
          selected: activo,
          onSelected: (_) => onSeleccionar(rango),
        );
      }).toList(),
    );
  }
}
