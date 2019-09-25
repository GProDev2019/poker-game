import 'package:flutter_test/flutter_test.dart';
import 'package:poker_game/poker_game.dart';
import 'package:poker_game/poker_game_logic/dispatcher.dart';
import 'package:poker_game/poker_game_store/poker_game_state.dart';
import 'package:redux/redux.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    final store = new Store<PokerGameState>(dispatchPokerGameAction,
        initialState: PokerGameState());
    await tester.pumpWidget(PokerGame(store));
  });
}
