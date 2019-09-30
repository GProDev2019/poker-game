import 'package:connectivity/connectivity.dart';
import 'package:poker_game/game_logic/actions.dart';
import 'package:poker_game/game_store/game_store.dart';
import 'package:redux/redux.dart';

bool hasInternetConnection = false;
bool isListeningForRoomsStarted = false;

Future<void> subscribeForConnectivityChange(Store<GameStore> store) async {
  final Connectivity connectivity = Connectivity();
  final ConnectivityResult currentConnectivity =
      await connectivity.checkConnectivity();
  if (currentConnectivity != ConnectivityResult.none) {
    store.dispatch(DownloadRoomsAction());
    hasInternetConnection = true;
    isListeningForRoomsStarted = true;
  }

  Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      hasInternetConnection = false;
    } else {
      hasInternetConnection = true;
      if (!isListeningForRoomsStarted) {
        store.dispatch(DownloadRoomsAction());
        isListeningForRoomsStarted = true;
      }
    }
  });
}
