import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/propagation_case.dart';
import '../viewmodel/propagacion_viewmodel.dart';

class PropagacionScreen extends ConsumerStatefulWidget {
  const PropagacionScreen({super.key});

  @override
  ConsumerState<PropagacionScreen> createState() => _PropagacionScreenState();
}

class _PropagacionScreenState extends ConsumerState<PropagacionScreen> {
  final TextEditingController _potenciaCtrl = TextEditingController();
  final TextEditingController _incertidumbreCtrl = TextEditingController();

  @override
  void dispose() {
    _potenciaCtrl.dispose();
    _incertidumbreCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PropagacionState estado = ref.watch(propagacionProvider);
    final PropagacionNotifier notifier = ref.read(propagacionProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Propagacion de incertidumbre')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          DropdownButtonFormField<CasoPropagacion>(
            value: estado.caso,
            decoration: const InputDecoration(labelText: 'Caso'),
            items: casosPropagacion
                .map((c) => DropdownMenuItem(
                    value: c,
                    child:
                        Text(c.descripcion, overflow: TextOverflow.ellipsis)))
                .toList(),
            onChanged: (c) {
              if (c != null) {
                notifier.elegirCaso(c);
                _potenciaCtrl.clear();
                _incertidumbreCtrl.clear();
              }
            },
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Voltaje medido: ${estado.medicionV.textoConIncertidumbre(2)} V'),
                  Text(
                      'Corriente medida: ${estado.medicionI.textoConIncertidumbre(3)} A'),
                  const SizedBox(height: 8),
                  const Text(
                    'Calcula P = V·I y su incertidumbre combinada U(P). '
                    'Pista: para un producto, las incertidumbres RELATIVAS se '
                    'combinan en cuadratura (regla GUM), no se suman directo.',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _potenciaCtrl,
            decoration: const InputDecoration(labelText: 'P = V·I (W)'),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _incertidumbreCtrl,
            decoration: const InputDecoration(labelText: 'U(P) (W)'),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              final double? p =
                  double.tryParse(_potenciaCtrl.text.replaceAll(',', '.'));
              final double? u =
                  double.tryParse(_incertidumbreCtrl.text.replaceAll(',', '.'));
              if (p != null && u != null) {
                notifier.evaluar(
                    potenciaIngresada: p, incertidumbreIngresada: u);
              }
            },
            child: const Text('Verificar'),
          ),
          if (estado.respuestaEvaluada) ...[
            const SizedBox(height: 16),
            Card(
              color: (estado.aciertoValor! && estado.aciertoIncertidumbre!)
                  ? Colors.green.withOpacity(0.15)
                  : Colors.orange.withOpacity(0.15),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'P correcto: ${estado.potenciaCorrecta!.toStringAsFixed(3)} W '
                        '(${estado.aciertoValor! ? "tu respuesta esta bien" : "revisa tu calculo"})'),
                    const SizedBox(height: 4),
                    Text(
                        'U(P) correcto: ${estado.incertidumbreCorrecta!.toStringAsFixed(4)} W '
                        '(${estado.aciertoIncertidumbre! ? "tu respuesta esta bien" : "revisa la combinacion en cuadratura"})'),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
