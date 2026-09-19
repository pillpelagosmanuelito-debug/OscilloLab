import 'package:flutter/material.dart';

import '../../assistant/view/asistente_panel.dart';
import 'inicio_screen.dart';
import 'progreso_screen.dart';

/// Cascaron de navegacion principal de OscilloLab: barra inferior de 3
/// destinos (Inicio, Progreso, Asistente). A diferencia de las apps
/// anteriores de la fabrica (que usan un Drawer lateral con la lista de
/// modulos), aqui los 5 modulos viven como tarjetas dentro de "Inicio" y
/// se navega a cada uno en una pantalla completa, para que la estructura
/// de navegacion no se vea igual entre proyectos.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _indice = 0;

  static const List<Widget> _paginas = [
    InicioScreen(),
    ProgresoScreen(),
    AsistentePanel(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _indice, children: _paginas),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indice,
        onDestinationSelected: (i) => setState(() => _indice = i),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Inicio'),
          NavigationDestination(
              icon: Icon(Icons.bar_chart_outlined),
              selectedIcon: Icon(Icons.bar_chart),
              label: 'Progreso'),
          NavigationDestination(
              icon: Icon(Icons.support_agent_outlined),
              selectedIcon: Icon(Icons.support_agent),
              label: 'Asistente'),
        ],
      ),
    );
  }
}
