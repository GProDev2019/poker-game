import 'poker_color.dart';

class PokerCard {
  int index;
  PokerColor color;
  bool selectedForReplace;

  PokerCard(this.index, this.color, [this.selectedForReplace = false])
      : assert(minCardIndex <= index && index <= maxCardIndex);
  static const int minCardIndex = 2;
  static const int maxCardIndex = 14;
}
