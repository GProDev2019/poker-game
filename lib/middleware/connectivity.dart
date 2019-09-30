import 'package:connectivity/connectivity.dart';
import 'package:poker_game/game_logic/actions.dart';
import 'package:poker_game/game_store/game_store.dart';
import 'package:redux/redux.dart';

bool hasInternetConnection = false;
bool isListeningForRooms = false;

void subscribeForConnectivityChange(Store<GameStore> store) {
  Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      hasInternetConnection = false;
    } else {
      hasInternetConnection = true;
      if (!isListeningForRooms) {
        store.dispatch(DownloadRoomsAction());
        isListeningForRooms = true;
      }
    }
  });
}
