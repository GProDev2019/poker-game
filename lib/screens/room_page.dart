import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:poker_game/game_logic/actions.dart';
import 'package:poker_game/game_store/game_store.dart';
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
          child: const Text('Start game'),
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

  _ViewModel(this.room, this.onStartGame, this.onBackToRooms);

  factory _ViewModel.create(Store<GameStore> store) {
    return _ViewModel(store.state.rooms[store.state.currentRoom], () {
      store.dispatch(StartOnlineGameAction());
      store.dispatch(NavigateToAction.push(Routes.onlineGame));
    }, () {
      store.dispatch(ExitRoomAction());
      store.dispatch(
          UpdateRoomAction(store.state.rooms[store.state.currentRoom]));
      store.dispatch(NavigateToAction.pop());
    });
  }
}
