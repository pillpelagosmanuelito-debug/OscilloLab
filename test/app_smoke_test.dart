import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oscillolab/app.dart';

void main() {
  testWidgets('OscilloLabApp arranca y muestra la pantalla de Inicio',
      (tester) async {
    await tester.pumpWidget(const ProviderScope(child: OscilloLabApp()));
    await tester.pumpAndSettle();

    expect(find.text('OscilloLab'), findsOneWidget);
    expect(find.text('1 · Instrumentos'), findsOneWidget);
    expect(find.text('2 · Mediciones'), findsOneWidget);
    expect(find.text('3 · Errores'), findsOneWidget);
    expect(find.text('4 · Calibración'), findsOneWidget);
    expect(find.text('5 · Casos industriales'), findsOneWidget);
  });

  testWidgets(
      'la barra de navegacion inferior cambia entre Inicio/Progreso/Asistente',
      (tester) async {
    await tester.pumpWidget(const ProviderScope(child: OscilloLabApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Progreso'));
    await tester.pumpAndSettle();
    expect(find.text('Tu progreso'), findsOneWidget);

    await tester.tap(find.text('Asistente'));
    await tester.pumpAndSettle();
    expect(find.text('Asistente técnico'), findsOneWidget);
  });
}
