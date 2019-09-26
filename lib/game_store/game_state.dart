import 'deck.dart';
import 'player.dart';

class GameState {
  Deck deck;
  List<Player> players;
  int currentPlayer;
  int numOfPlayers;
  HandOutStrategy handOutStrategy;
  bool gameEnded;
  static const int maxNumOfPlayers = 9;

  GameState(
      [this.numOfPlayers = 2,
      this.handOutStrategy = HandOutStrategy.oneByOneCard])
      : assert(numOfPlayers < maxNumOfPlayers),
        deck = Deck.initial(),
        players = List<Player>.generate(
            numOfPlayers, (int index) => Player(index),
            growable: false),
        currentPlayer = 0,
        gameEnded = false;

  factory GameState.initial() => GameState();
}

enum HandOutStrategy { oneByOneCard, allCardsAtOnce }
