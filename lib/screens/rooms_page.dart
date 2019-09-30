import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:poker_game/game_logic/actions.dart';
import 'package:poker_game/game_store/game_store.dart';
import 'package:poker_game/middleware/room.dart';
import 'package:poker_game/routes.dart';
import 'package:redux/redux.dart';

class RoomsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => StoreConnector<GameStore, _ViewModel>(
      converter: (Store<GameStore> store) => _ViewModel.create(store),
      builder: (BuildContext context, _ViewModel viewModel) => Scaffold(
          appBar: AppBar(
            title: const Text('Rooms'),
          ),
          body: _createWidget(context, viewModel)));

  Widget _createWidget(BuildContext context, _ViewModel viewModel) {
    return Column(
      children: <Widget>[
        ListView.builder(
            shrinkWrap: true,
            itemCount: viewModel.rooms.length,
            itemBuilder: (BuildContext context, int roomId) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    viewModel
                        .onEnterRoom(roomId + 1); // Room 0 is for offline game
                  },
                  child: Card(
                    child: Text(
                      'Room ${viewModel.rooms[roomId].title}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                ),
              );
            }),
        const Padding(padding: EdgeInsets.all(7.0)),
        FlatButton(
          color: Colors.green,
          child: const Text('Create new room'),
          onPressed: viewModel.onCreateNewRoom,
        ),
        const Padding(padding: EdgeInsets.all(7.0)),
        FlatButton(
          color: Colors.red,
          child: const Text('Back to menu'),
          onPressed: viewModel.onBackToMenu,
        )
      ],
    );
  }
}

class _ViewModel {
  final List<Room> rooms;
  final Function() onBackToMenu;
  final Function() onCreateNewRoom;
  final Function(int roomId) onEnterRoom;

  _ViewModel(
      this.rooms, this.onBackToMenu, this.onCreateNewRoom, this.onEnterRoom);

  factory _ViewModel.create(Store<GameStore> store) {
    return _ViewModel(store.state.rooms, () {
      store.dispatch(BackToMenuAction());
      store.dispatch(NavigateToAction.pop());
    }, () {
      store.dispatch(CreateRoomAction(Room('title1', store.state.gameState)));
    }, (int roomId) {
      store.dispatch(EnterRoomAction(roomId));
      store.dispatch(UpdateRoomAction(store.state.rooms[roomId]));
      store.dispatch(NavigateToAction.push(Routes.room));
    });
  }
}
