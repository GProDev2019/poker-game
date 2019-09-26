import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:poker_game/poker_game_view/main_menu_page.dart';

import 'package:redux/redux.dart';
import 'poker_game_logic/dispatcher.dart';
import 'poker_game_store/poker_game_state.dart';

class PokerGame extends StatelessWidget {
  final Store<PokerGameState> store = Store<PokerGameState>(
      dispatchPokerGameAction,
      initialState: PokerGameState.initial());
  final String title = 'Poker game';

  @override
  Widget build(BuildContext context) {
    return StoreProvider<PokerGameState>(
        store: store,
        child: MaterialApp(
            theme: ThemeData.light(), title: title, home: MainMenuPage()));
  }
}
