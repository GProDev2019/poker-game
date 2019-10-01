import 'package:json_annotation/json_annotation.dart';
import 'package:poker_game/game_store/card_info.dart';

import 'hand_name.dart';

part 'hand_strength.g.dart';

@JsonSerializable()
class HandStrength implements Comparable<HandStrength> {
  HandName handName;
  CardRank higherCardRank;
  CardRank lowerCardRank;
  List<CardRank> cardRanks;
  HandStrength(this.handName, this.cardRanks,
      [this.higherCardRank, this.lowerCardRank]);

  @override
  int compareTo(HandStrength otherHandStrength) {
    if (handName.index > otherHandStrength.handName.index) {
      return -1;
    } else if (handName.index == otherHandStrength.handName.index) {
      return _checkStrengthWhenEqual(otherHandStrength);
    } else {
      return 1;
    }
  }

  int _checkStrengthWhenEqual(HandStrength otherHandStrength) {
    switch (handName) {
      case HandName.highCard:
      case HandName.straight:
      case HandName.flush:
      case HandName.poker:
      case HandName.threeOfAKind:
      case HandName.fourOfAKind:
      case HandName.fullHouse:
        for (int i = cardRanks.length - 1; i >= 0; i--) {
          if (cardRanks[i].index > otherHandStrength.cardRanks[i].index) {
            return -1;
          } else if (cardRanks[i].index <
              otherHandStrength.cardRanks[i].index) {
            return 1;
          }
        }
        return 0;
      case HandName.pair:
        if (higherCardRank.index > otherHandStrength.higherCardRank.index) {
          return -1;
        } else if (higherCardRank.index <
            otherHandStrength.higherCardRank.index) {
          return 1;
        }
        final List<CardRank> leftCardRanks =
            cardRanks.where((CardRank card) => card != higherCardRank).toList();
        final List<CardRank> rightCardRanks = otherHandStrength.cardRanks
            .where((CardRank card) => card != higherCardRank)
            .toList();
        for (int i = leftCardRanks.length - 1; i >= 0; i--) {
          if (leftCardRanks[i].index > rightCardRanks[i].index) {
            return -1;
          } else if (leftCardRanks[i].index < rightCardRanks[i].index) {
            return 1;
          }
        }
        return 0;
      case HandName.twoPairs:
        if (higherCardRank.index > otherHandStrength.higherCardRank.index) {
          return -1;
        } else if (higherCardRank.index <
            otherHandStrength.higherCardRank.index) {
          return 1;
        }
        if (lowerCardRank.index > otherHandStrength.lowerCardRank.index) {
          return -1;
        } else if (lowerCardRank.index <
            otherHandStrength.lowerCardRank.index) {
          return 1;
        }
        final List<CardRank> leftCardRanks = cardRanks
            .where((CardRank card) =>
                card != higherCardRank && card != lowerCardRank)
            .toList();
        final List<CardRank> rightCardRanks = otherHandStrength.cardRanks
            .where((CardRank card) =>
                card != higherCardRank && card != lowerCardRank)
            .toList();
        for (int i = leftCardRanks.length - 1; i >= 0; i--) {
          if (leftCardRanks[i].index > rightCardRanks[i].index) {
            return -1;
          } else if (leftCardRanks[i].index < rightCardRanks[i].index) {
            return 1;
          }
        }
        return 0;
      default:
        throw 'Something is wrong with players hands as comparison of these two is not supported. First player: $handName, Second player: ${otherHandStrength.handName}';
    }
  }

  factory HandStrength.fromJson(Map<String, dynamic> json) =>
      _$HandStrengthFromJson(json);

  Map<String, dynamic> toJson() => _$HandStrengthToJson(this);
}
