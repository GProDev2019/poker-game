import 'package:json_annotation/json_annotation.dart';
import 'playing_card.dart';

part 'hand.g.dart';

@JsonSerializable()
class Hand {
  List<PlayingCard> cards;
  static const int maxNumOfCards = 5;

  Hand() : cards = <PlayingCard>[];

  factory Hand.fromJson(Map<String, dynamic> json) => _$HandFromJson(json);

  Map<String, dynamic> toJson() => _$HandToJson(this);
}
