import 'package:json_annotation/json_annotation.dart';
import 'card_info.dart';
import 'playing_card.dart';

part 'deck.g.dart';

@JsonSerializable()
class Deck {
  List<PlayingCard> cards;
  static const int numOfCards = 52;

  Deck(this.cards);

  factory Deck.initial() {
    final List<PlayingCard> cards = <PlayingCard>[];
    for (CardColor color in CardColor.values) {
      for (CardRank rank in CardRank.values) {
        cards.add(PlayingCard(rank, color));
      }
    }
    return Deck(cards);
  }

  factory Deck.fromJson(Map<String, dynamic> json) => _$DeckFromJson(json);

  Map<String, dynamic> toJson() => _$DeckToJson(this);
}
