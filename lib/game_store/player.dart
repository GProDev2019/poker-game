import 'package:poker_game/game_logic/hand_names.dart';

import 'hand.dart';

class Player implements Comparable<Player> {
  Hand hand;
  HandStrength handStrength;
  int playerIndex;
  bool replacedCards = false;

  Player(this.playerIndex) : hand = Hand();

  @override
  int compareTo(Player otherPlayer) {
    return handStrength.compareTo(otherPlayer.handStrength);
  }
}
