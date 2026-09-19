import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oscillolab/app.dart';

void main() {
  testWidgets('OscilloLabApp arranca sin errores', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: OscilloLabApp()));
    await tester.pumpAndSettle();

    expect(find.text('OscilloLab'), findsOneWidget);
  });
}
