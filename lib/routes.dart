import 'package:flutter/material.dart';
import 'package:poker_game/screens/game_page.dart';
import 'package:poker_game/screens/results_page.dart';
import 'package:poker_game/screens/room_page.dart';
import 'package:poker_game/screens/rooms_page.dart';
import 'package:poker_game/screens/start.dart';

class Routes {
  static const String mainMenu = '/';
  static const String game = '/game';
  static const String rooms = '/rooms';
  static const String room = '/room';
  static const String results = '/results';

  static MaterialPageRoute<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case mainMenu:
        return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => StartPage(),
          settings: settings,
        );
        break;
      case game:
        return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => GamePage(),
          settings: settings,
        );
        break;
      case rooms:
        return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => RoomsPage(),
          settings: settings,
        );
        break;
      case room:
        return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => RoomPage(),
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
