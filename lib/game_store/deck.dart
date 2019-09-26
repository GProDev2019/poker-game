import 'playing_card.dart';

class Deck {
  List<PlayingCard> cards;
  static const int numOfCards = 52;

  Deck(this.cards);

  factory Deck.initial() {
    final List<PlayingCard> cards = <PlayingCard>[];
    for (PokerColor color in PokerColor.values) {
      for (PokerRank rank in PokerRank.values) {
        cards.add(PlayingCard(rank, color));
      }
    }
    return Deck(cards);
  }
}
