import 'poker_deck.dart';
import 'poker_player.dart';

class PokerGameState {
  PokerDeck deck;
  List<PokerPlayer> players;
  int currentPlayer;
  int numOfPlayers;
  HandOutStrategy handOutStrategy;
  static const int maxNumOfPlayers = 9;

  PokerGameState(
      [this.numOfPlayers = 2,
      this.handOutStrategy = HandOutStrategy.oneByOneCard])
      : assert(numOfPlayers < maxNumOfPlayers),
        deck = PokerDeck.initial(),
        players = List<PokerPlayer>.generate(
            numOfPlayers, (int index) => PokerPlayer(index),
            growable: false),
        currentPlayer = 0;

  factory PokerGameState.initial() => PokerGameState();
}

enum HandOutStrategy { oneByOneCard, allCardsAtOnce }
