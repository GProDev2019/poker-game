import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:poker_game/game_logic/actions.dart';
import 'package:poker_game/game_store/game_state.dart';
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
            itemBuilder: (BuildContext context, int roomIndex) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    viewModel.onEnterRoom(roomIndex);
                  },
                  child: ListTile(
                    title: Text(
                      'Room ${viewModel.rooms[roomIndex].title}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22),
                    ),
                    trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => viewModel.onDeleteRoom(roomIndex)),
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
  final Function(int roomIndex) onEnterRoom;
  final Function(int roomIndex) onDeleteRoom;

  _ViewModel(this.rooms, this.onBackToMenu, this.onCreateNewRoom,
      this.onEnterRoom, this.onDeleteRoom);

  factory _ViewModel.create(Store<GameStore> store) {
    return _ViewModel(store.state.onlineRooms, () {
      store.dispatch(BackToMenuAction());
      store.dispatch(NavigateToAction.pop());
    }, () {
      store.dispatch(CreateRoomAction(Room('title1', GameState())));
    }, (int roomIndex) {
      store.dispatch(EnterRoomAction(roomIndex));
      store.dispatch(UpdateRoomAction(store.state.onlineRooms[roomIndex]));
      store.dispatch(NavigateToAction.push(Routes.room));
    }, (int roomIndex) {
      store.dispatch(DeleteRooomAction(store.state.onlineRooms[roomIndex].id));
    });
  }
}
