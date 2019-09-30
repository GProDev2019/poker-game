import 'package:connectivity/connectivity.dart';
import 'package:poker_game/game_logic/actions.dart';
import 'package:poker_game/game_store/game_store.dart';
import 'package:redux/redux.dart';

void subscribeForConnectivityChange(Store<GameStore> store) {
  Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      store.dispatch(ClearRoomsAction());
    } else {
      if (store.state.onlineRooms.length == 1) {
        // ToDo: Do it prettier
        store.dispatch(DownloadRoomsAction());
      }
    }
  });
}
