import 'poker_card.dart';

class PokerDeck {
  List<PokerCard> cards;
  static const int numOfCards = 52;

  PokerDeck(this.cards);

  factory PokerDeck.initial() {
    final List<PokerCard> cards = <PokerCard>[];
    for (PokerColor color in PokerColor.values) {
      for (PokerRank rank in PokerRank.values) {
        cards.add(PokerCard(rank, color));
      }
    }
    return PokerDeck(cards);
  }
}
