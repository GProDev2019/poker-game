enum CardColor { hearts, diamonds, clubs, spades }

enum CardRank {
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
}
