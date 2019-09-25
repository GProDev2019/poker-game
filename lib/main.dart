import 'package:flutter/material.dart';
import 'poker_game.dart';
import 'poker_game_logic/dispatcher.dart';
import 'poker_game_store/poker_game_state.dart';

import 'package:redux/redux.dart';

void main() {
  final store = new Store<PokerGameState>(dispatchPokerGameAction,
      initialState: PokerGameState());

  runApp(PokerGame(store));
}
