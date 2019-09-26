import 'poker_deck.dart';
import 'poker_player.dart';

class PokerGameState {
  PokerDeck deck;
  List<PokerPlayer> players;
  int currentPlayer;
  static const int numOfPlayers = 2;

  PokerGameState(this.players) : deck = PokerDeck.initial();

  factory PokerGameState.initial() =>
      PokerGameState(List<PokerPlayer>(numOfPlayers));
}
