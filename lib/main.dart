import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:poker_game/game_logic/dispatcher.dart';
import 'package:poker_game/game_store/game_state.dart';
import 'package:poker_game/screens/start.dart';
import 'package:poker_game/screens/offline_game.dart';
import 'package:poker_game/screens/results.dart';

void main() {
  runApp(PokerGame());
}

class PokerGame extends StatelessWidget {
  final String title = 'Poker game';
  static final Dispatcher dispatcher = Dispatcher();
  final Store<GameState> store = Store<GameState>(
      dispatcher.dispatchPokerGameAction,
      initialState: GameState.initial());

  @override
  Widget build(BuildContext context) {
    return StoreProvider<GameState>(
        store: store,
        child: MaterialApp(
            initialRoute: '/',
            routes: <String, WidgetBuilder>{
              '/': (BuildContext context) => StartPage(),
              '/offlineGame': (BuildContext context) => OfflineGamePage(),
              '/results': (BuildContext context) => ResultsPage()
            },
            theme: ThemeData.light(),
            title: title));
  }
}
