import 'package:flutter_test/flutter_test.dart';
import 'package:poker_game/poker_game.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(PokerGame());
  });
}
