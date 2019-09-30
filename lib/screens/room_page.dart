import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:poker_game/game_logic/actions.dart';
import 'package:poker_game/game_logic/dispatcher.dart';
import 'package:poker_game/game_store/game_state.dart';
import 'package:poker_game/game_store/game_store.dart';
import 'package:poker_game/game_store/hand.dart';
import 'package:poker_game/game_store/player.dart';
import 'package:poker_game/middleware/room.dart';
import 'package:poker_game/routes.dart';
import 'package:redux/redux.dart';

class RoomPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => StoreConnector<GameStore, _ViewModel>(
      converter: (Store<GameStore> store) => _ViewModel.create(store),
      builder: (BuildContext context, _ViewModel viewModel) => Scaffold(
          appBar: AppBar(
            title: const Text('Room'),
          ),
          body: _createWidget(context, viewModel)));

  Widget _createWidget(BuildContext context, _ViewModel viewModel) {
    return Column(
      children: <Widget>[
        if (viewModel.room.gameState.players != null)
          ListView.builder(
              shrinkWrap: true,
              itemCount: viewModel.room.gameState.players.length,
              itemBuilder: (BuildContext context, int position) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Text(
                      'Player ${viewModel.room.gameState.players[position].playerIndex}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                );
              })
        else
          Container(),
        const Padding(padding: EdgeInsets.all(7.0)),
        FlatButton(
          color: Colors.green,
          child: Text(viewModel.startGameButtonText),
          onPressed: viewModel.onStartGame,
        ),
        const Padding(padding: EdgeInsets.all(7.0)),
        FlatButton(
          color: Colors.red,
          child: const Text('Back to rooms'),
          onPressed: viewModel.onBackToRooms,
        )
      ],
    );
  }
}

class _ViewModel {
  final Room room;
  final Function() onStartGame;
  final Function() onBackToRooms;
  final String startGameButtonText;

  _ViewModel(this.room, this.onStartGame, this.onBackToRooms,
      this.startGameButtonText);

  factory _ViewModel.create(Store<GameStore> store) {
    // ToDo: Do it prettier
    String startGameButtonText = 'Start game';
    if (onlinePlayerIndex != -1 &&
        Dispatcher.getGameState(store.state)
                .players[onlinePlayerIndex]
                .hand
                .cards
                .length ==
            Hand.maxNumOfCards) {
      startGameButtonText = 'Join game';
    }

    return _ViewModel(store.state.rooms[store.state.currentRoom], () {
      if (onlinePlayerIndex != -1 &&
          Dispatcher.getGameState(store.state)
                  .players[onlinePlayerIndex]
                  .hand
                  .cards
                  .length ==
              Hand.maxNumOfCards) {
        store.dispatch(NavigateToAction.push(
            Routes.onlineGame)); // Join online game if someone else run it
      } else {
        final int numOfPlayers =
            Dispatcher.getGameState(store.state).players.length;
        if (GameState.minNumOfPlayers <= numOfPlayers &&
            numOfPlayers <= GameState.maxNumOfPlayers) {
          store.dispatch(StartOnlineGameAction(numOfPlayers));
          store.dispatch(
              UpdateRoomAction(store.state.rooms[store.state.currentRoom]));
          store.dispatch(NavigateToAction.push(Routes.onlineGame));
        } else {
          // ToDo: Show error
        }
      }
    }, () {
      store.dispatch(ExitRoomAction());
      store.dispatch(
          UpdateRoomAction(store.state.rooms[store.state.currentRoom]));
      store.dispatch(NavigateToAction.pop());
    }, startGameButtonText);
  }
}