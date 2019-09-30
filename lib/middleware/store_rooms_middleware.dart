import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:poker_game/game_logic/actions.dart';
import 'package:poker_game/game_store/game_store.dart';
import 'package:redux/redux.dart';

import 'firestore_rooms.dart';
import 'room.dart';

List<Middleware<GameStore>> createStoreMiddleware(
    FirestoreRooms firestoreRooms) {
  return <Middleware<GameStore>>[
    TypedMiddleware<GameStore, DownloadRoomsAction>(
      _firestoreDownloadRooms(firestoreRooms),
    ),
    TypedMiddleware<GameStore, CreateRoomAction>(
      _firestoreCreateNewRoom(firestoreRooms),
    ),
    TypedMiddleware<GameStore, DeleteRooomAction>(
      _firestoreDeleteRoom(firestoreRooms),
    ),
    TypedMiddleware<GameStore, UpdateRoomAction>(
      _firestoreUpdateRoom(firestoreRooms),
    ),
    NavigationMiddleware<GameStore>(),
  ];
}

void Function(
  Store<GameStore> store,
  DownloadRoomsAction action,
  NextDispatcher next,
) _firestoreDownloadRooms(
  FirestoreRooms firestoreRooms,
) {
  return (Store<GameStore> store, DownloadRoomsAction action,
      NextDispatcher next) {
    firestoreRooms.rooms().listen((List<Room> rooms) {
      store.dispatch(LoadRoomsAction(rooms));
    });
  };
}

void Function(
  Store<GameStore> store,
  CreateRoomAction action,
  NextDispatcher next,
) _firestoreCreateNewRoom(
  FirestoreRooms firestoreRooms,
) {
  return (Store<GameStore> store, CreateRoomAction action,
      NextDispatcher next) {
    firestoreRooms.createNewRoom(action.room);
  };
}

void Function(
  Store<GameStore> store,
  DeleteRooomAction action,
  NextDispatcher next,
) _firestoreDeleteRoom(
  FirestoreRooms firestoreRooms,
) {
  return (Store<GameStore> store, DeleteRooomAction action,
      NextDispatcher next) {
    firestoreRooms.deleteRoom(action.roomId);
  };
}

void Function(
  Store<GameStore> store,
  UpdateRoomAction action,
  NextDispatcher next,
) _firestoreUpdateRoom(
  FirestoreRooms firestoreRooms,
) {
  return (Store<GameStore> store, UpdateRoomAction action,
      NextDispatcher next) {
    firestoreRooms.updateRoom(action.room);
  };
}
