import 'poker_hand.dart';

class PokerPlayer {
  PokerHand hand;
  int playerIndex;

  PokerPlayer(this.playerIndex) : hand = PokerHand();
}
