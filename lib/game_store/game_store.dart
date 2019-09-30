import 'package:poker_game/middleware/room.dart';

import 'game_state.dart';
import 'local_store.dart';

class GameStore {
  LocalStore localStore = LocalStore();
  GameState offlineGameState;
  List<Room> onlineRooms = <Room>[];

  GameStore();
}
