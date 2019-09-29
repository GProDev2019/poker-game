import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:redux/redux.dart';

import 'package:poker_game/game_logic/dispatcher.dart';
import 'package:poker_game/game_store/game_state.dart';
import 'package:poker_game/routes.dart';

void main() {
  runApp(PokerGame());
}

class PokerGame extends StatelessWidget {
  final String title = 'Poker game';
  static final Dispatcher dispatcher = Dispatcher();
  final Store<GameState> store = Store<GameState>(
      dispatcher.dispatchPokerGameAction,
      initialState: GameState.initial(),
      middleware: [NavigationMiddleware<GameState>()]);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<GameState>(
        store: store,
        child: MaterialApp(
            navigatorKey: NavigatorHolder.navigatorKey,
            onGenerateRoute: (RouteSettings settings) =>
                Routes.getRoute(settings),
            theme: ThemeData.light(),
            title: title));
  }
}
