import 'package:json_annotation/json_annotation.dart';

import 'card_info.dart';

part 'playing_card.g.dart';

@JsonSerializable()
class PlayingCard implements Comparable<PlayingCard> {
  static const CardRank minCardRank = CardRank.two;
  static const CardRank maxCardRank = CardRank.ace;
  CardRank rank;
  CardColor color;
  bool selectedForReplace;

  PlayingCard(this.rank, this.color, [this.selectedForReplace = false])
      : assert(
            minCardRank.index <= rank.index && rank.index <= maxCardRank.index);

  @override
  int compareTo(PlayingCard otherCard) {
    if (rank == otherCard.rank) {
      return color.index - otherCard.color.index;
    } else {
      return rank.index - otherCard.rank.index;
    }
  }

  factory PlayingCard.fromJson(Map<String, dynamic> json) =>
      _$PlayingCardFromJson(json);

  Map<String, dynamic> toJson() => _$PlayingCardToJson(this);
}
