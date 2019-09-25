class PokerCard {
  bool selectedForReplace;
  int index;
  PokerCard(index, [this.selectedForReplace = false]) {
    assert(minCardIndex <= index && index <= maxCardIndex);
    this.index = index;
  }
  static const int minCardIndex = 2;
  static const int maxCardIndex = 14;
}
