import 'poker_card.dart';

class PokerDeck {
  List<PokerCard> cards;
  static const int numOfCards = 52;

  PokerDeck(this.cards);

  factory PokerDeck.initial() {
    final List<PokerCard> cards = <PokerCard>[];
    for (PokerColor color in PokerColor.values) {
      for (int index = PokerCard.minCardIndex;
          index <= PokerCard.maxCardIndex;
          index++) {
        cards.add(PokerCard(index, color));
      }
    }
    return PokerDeck(cards);
  }
}
