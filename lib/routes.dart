import 'package:flutter/material.dart';
import 'package:poker_game/screens/offline_game.dart';
import 'package:poker_game/screens/results.dart';
import 'package:poker_game/screens/start.dart';

class Routes {
  static const String mainMenu = '/';
  static const String offlineGame = '/offlineGame';
  static const String results = '/results';

  static MaterialPageRoute<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case mainMenu:
        return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => StartPage(),
          settings: settings,
        );
        break;
      case offlineGame:
        return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => OfflineGamePage(),
          settings: settings,
        );
        break;
      case results:
        return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => ResultsPage(),
          settings: settings,
        );
      default:
        return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => StartPage(),
          settings: settings,
        );
    }
  }
}
