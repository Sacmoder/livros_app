import 'package:flutter_test/flutter_test.dart';
import 'package:ony/main.dart';

void main() {
  testWidgets('o app inicia com a tela principal', (tester) async {
    await tester.pumpWidget(const OnyApp());

    expect(find.text('Meus livros'), findsOneWidget);
    expect(find.text('Lidos'), findsOneWidget);
    expect(find.text('Desejados'), findsOneWidget);
  });
}
