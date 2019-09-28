import 'hand.dart';

class Player {
  Hand hand;
  int playerIndex;
  bool replacedCards = false;

  Player(this.playerIndex) : hand = Hand();
}
