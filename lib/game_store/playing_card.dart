import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import 'card_info.dart';

part 'playing_card.g.dart';

@JsonSerializable()
class PlayingCard implements Comparable<PlayingCard> {
  static const CardRank minCardRank = CardRank.two;
  static const CardRank maxCardRank = CardRank.ace;
  static const Image cardBackImage = Image(
    image: AssetImage('assets/cards/red_back.png'),
    fit: BoxFit.contain,
  );
  String cardImagePath;
  CardRank rank;
  CardColor color;
  bool selectedForReplace;

  PlayingCard(this.rank, this.color, [this.selectedForReplace = false])
      : assert(minCardRank.index <= rank.index &&
            rank.index <= maxCardRank.index) {
    String rankImagePath;
    String colorImagePath;
    switch (rank) {
      case CardRank.jack:
        rankImagePath = 'J';
        break;
      case CardRank.queen:
        rankImagePath = 'Q';
        break;
      case CardRank.king:
        rankImagePath = 'K';
        break;
      case CardRank.ace:
        rankImagePath = 'A';
        break;
      default:
        rankImagePath = (rank.index + 2).toString();
        break;
    }
    switch (color) {
      case CardColor.clubs:
        colorImagePath = 'C';
        break;
      case CardColor.diamonds:
        colorImagePath = 'D';
        break;
      case CardColor.hearts:
        colorImagePath = 'H';
        break;
      case CardColor.spades:
        colorImagePath = 'S';
        break;
    }
    cardImagePath = 'assets/cards/$rankImagePath$colorImagePath.png';
  }

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
