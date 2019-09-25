import 'poker_deck.dart';
import 'poker_player.dart';

class PokerGameState {
  PokerDeck deck;
  List<PokerPlayer> players = List(numOfPlayers);
  int currentPlayer;
  static const int numOfPlayers = 2;
}
