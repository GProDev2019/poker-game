import 'package:json_annotation/json_annotation.dart';
import 'package:poker_game/game_logic/hand_strength.dart';

import 'hand.dart';

part 'player.g.dart';

@JsonSerializable()
class Player implements Comparable<Player> {
  Hand hand;
  HandStrength handStrength;
  int playerIndex;
  bool replacedCards;

  Player(this.playerIndex)
      : hand = Hand(),
        replacedCards = false;

  @override
  int compareTo(Player otherPlayer) {
    return handStrength.compareTo(otherPlayer.handStrength);
  }

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerToJson(this);
}
