import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:redux/redux.dart';

import 'poker_game_store/poker_game_state.dart';

class PokerGame extends StatelessWidget {
  final Store<PokerGameState> store;
  final String title = "Poker game";

  const PokerGame(this.store);

  @override
  Widget build(BuildContext context) {
    return new StoreProvider<PokerGameState>(
        store: store,
        child: new MaterialApp(
            theme: new ThemeData.dark(),
            title: title,
            home: new Scaffold(
                appBar: new AppBar(
              title: new Text(title),
            ))));
  }
}
