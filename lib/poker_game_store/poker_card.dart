enum PokerColor { hearts, diamonds, clubs, spades }

enum PokerRank {
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  nine,
  ten,
  jack,
  queen,
  king,
  ace
}

class PokerCard implements Comparable<PokerCard> {
  PokerRank rank;
  PokerColor color;
  bool selectedForReplace;

  PokerCard(this.rank, this.color, [this.selectedForReplace = false])
      : assert(
            minCardRank.index <= rank.index && rank.index <= maxCardRank.index);
  static const PokerRank minCardRank = PokerRank.two;
  static const PokerRank maxCardRank = PokerRank.ace;

  @override
  int compareTo(PokerCard oCard) {
    if (rank == oCard.rank) {
      return color.index - oCard.color.index;
    } else {
      return rank.index - oCard.rank.index;
    }
  }
}
