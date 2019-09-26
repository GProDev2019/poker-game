import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:poker_game/game_logic/dispatcher.dart';
import 'package:poker_game/game_store/game_state.dart';
import 'package:poker_game/screens/start.dart';

void main() {
  runApp(PokerGame());
}

class PokerGame extends StatelessWidget {
  final String title = 'Poker game';
  final Store<GameState> store = Store<GameState>(
      dispatchPokerGameAction,
      initialState: GameState.initial());

  @override
  Widget build(BuildContext context) {
    return StoreProvider<GameState>(
        store: store,
        child: MaterialApp(
            theme: ThemeData.light(), title: title, home: StartPage()));
  }
}
