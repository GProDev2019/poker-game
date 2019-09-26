enum PokerColor { hearts, diamonds, clubs, spades }

class PokerCard implements Comparable<PokerCard> {
  int index;
  PokerColor color;
  bool selectedForReplace;

  PokerCard(this.index, this.color, [this.selectedForReplace = false])
      : assert(minCardIndex <= index && index <= maxCardIndex);
  static const int minCardIndex = 2;
  static const int maxCardIndex = 14;

  @override
  int compareTo(PokerCard oCard) {
    if (index == oCard.index) {
      return color.index - oCard.color.index;
    } else {
      return index - oCard.index;
    }
  }
}
