import 'playing_card.dart';

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
}
