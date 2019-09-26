class PokerCard {
  static const int minCardIndex = 2;
  static const int maxCardIndex = 14;
  bool selectedForReplace;
  int index;

  PokerCard(this.index, this.selectedForReplace)
      : assert(minCardIndex <= index && index <= maxCardIndex);
}