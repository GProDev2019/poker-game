import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:redux/redux.dart';

import 'package:poker_game/game_logic/dispatcher.dart';
import 'package:poker_game/routes.dart';

import 'game_store/game_store.dart';
import 'middleware/connectivity.dart';
import 'middleware/firestore_rooms.dart';
import 'middleware/store_rooms_middleware.dart';

void main() {
  runApp(PokerGame());
}

class PokerGame extends StatelessWidget {
  final String title = 'Poker game';
  static final Dispatcher dispatcher = Dispatcher();
  static final FirestoreRooms firestoreRooms =
      FirestoreRooms(Firestore.instance);
  final Store<GameStore> store = Store<GameStore>(
    dispatcher.dispatchPokerGameAction,
    initialState: GameStore.initial(),
    middleware: createStoreMiddleware(firestoreRooms),
  );

  PokerGame() {
    subscribeForConnectivityChange(store);
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider<GameStore>(
        store: store,
        child: MaterialApp(
            navigatorKey: NavigatorHolder.navigatorKey,
            onGenerateRoute: (RouteSettings settings) =>
                Routes.getRoute(settings),
            theme: ThemeData.light(),
            title: title));
  }
}
