import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:poker_game/game_logic/actions.dart';
import 'package:poker_game/game_store/game_state.dart';
import 'package:poker_game/game_store/game_store.dart';
import 'package:poker_game/middleware/room.dart';
import 'package:poker_game/routes.dart';
import 'package:poker_game/utils/constants.dart';
import 'package:poker_game/utils/widgets.dart';
import 'package:redux/redux.dart';

class RoomsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => StoreConnector<GameStore, _ViewModel>(
      converter: (Store<GameStore> store) => _ViewModel.create(store),
      builder: (BuildContext context, _ViewModel viewModel) => Scaffold(
          appBar: AppBar(
            title: const Text('Rooms'),
          ),
          backgroundColor: greenBackground,
          body: _createWidget(context, viewModel)));

  Widget _createWidget(BuildContext context, _ViewModel viewModel) {
    return Column(
      children: <Widget>[
        const Padding(padding: EdgeInsets.all(7.0)),
        AutoSizeText(
          viewModel.playerName,
          style: const TextStyle(
              fontFamily: 'Casino', fontSize: 30, color: goldFontColor),
          maxFontSize: 30,
          maxLines: 1,
        ),
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
                  child: Card(
                    color: goldFontColor,
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      color: goldFontColor,
                      child: ListTile(
                        title: Text(
                          'Room: ${viewModel.rooms[roomIndex].id.substring(0, 5)}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 22),
                        ),
                        trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => viewModel.onDeleteRoom(roomIndex)),
                      ),
                    ),
                  ),
                ),
              );
            }),
        const Padding(padding: EdgeInsets.all(7.0)),
        createPokerButton('Create new room', viewModel.onCreateNewRoom),
        const Padding(padding: EdgeInsets.all(7.0)),
        createPokerButton('Login using facebook', viewModel.onFacebookLogin),
      ],
    );
  }
}

class _ViewModel {
  final String playerName;
  final List<Room> rooms;
  final Function() onBackToMenu;
  final Function() onCreateNewRoom;
  final Function(int roomIndex) onEnterRoom;
  final Function(int roomIndex) onDeleteRoom;
  final Function() onFacebookLogin;

  _ViewModel(
      this.playerName,
      this.rooms,
      this.onBackToMenu,
      this.onCreateNewRoom,
      this.onEnterRoom,
      this.onDeleteRoom,
      this.onFacebookLogin);

  factory _ViewModel.create(Store<GameStore> store) {
    final Function() onFacebookLogin = () {
      store.dispatch(FacebookAuthAction());
    };

    return _ViewModel(
        store.state.localStore.playerName, store.state.onlineRooms, () {
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
    }, onFacebookLogin);
  }
}
