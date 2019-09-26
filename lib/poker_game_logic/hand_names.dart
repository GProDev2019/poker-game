import 'package:poker_game/poker_game_store/poker_card.dart';

enum HandName {
  highCard,
  pair,
  twoPairs,
  threeOfAKind,
  straight,
  flush,
  fullHouse,
  fourOfAKind,
  poker
}

class HandStrength {
  HandName handName;
  List<PokerRank> cardRanks;
  HandStrength(this.handName, this.cardRanks);

  // ToDo: Implement comparator
}

class HandStrengthChecker {
  List<PokerCard> _cards;
  HandStrength checkHandStrength(List<PokerCard> cards) {
    _cards = cards;
    return _isPoker() ??
        _isFourOfAKind() ??
        _isFullHouse() ??
        _isFlush() ??
        _isStraight() ??
        _isThreeOfAKind() ??
        _isTwoPairs() ??
        _isPair() ??
        _isHighCard();
  }

  HandStrength _isPoker() {
    for (int cardNum = 0; cardNum < _cards.length; cardNum++) {
      if (((_cards[cardNum].rank.index + 1) !=
              _cards[cardNum + 1].rank.index) ||
          ((_cards[cardNum].color.index) != _cards[cardNum + 1].color.index)) {
        return null;
      }
    }
    return HandStrength(HandName.poker, <PokerRank>[_cards.last.rank]);
  }

  HandStrength _isFourOfAKind() {
    // ToDo
    return HandStrength(HandName.fourOfAKind, <PokerRank>[]);
  }

  HandStrength _isFullHouse() {
    // ToDo
    return HandStrength(HandName.fullHouse, <PokerRank>[]);
  }

  HandStrength _isFlush() {
    // ToDo
    return HandStrength(HandName.flush, <PokerRank>[]);
  }

  HandStrength _isStraight() {
    // ToDo
    return HandStrength(HandName.straight, <PokerRank>[]);
  }

  HandStrength _isThreeOfAKind() {
    // ToDo
    return HandStrength(HandName.threeOfAKind, <PokerRank>[]);
  }

  HandStrength _isTwoPairs() {
    // ToDo
    return HandStrength(HandName.twoPairs, <PokerRank>[]);
  }

  HandStrength _isPair() {
    // ToDo
    return HandStrength(HandName.pair, <PokerRank>[]);
  }

  HandStrength _isHighCard() {
    // ToDo
    return HandStrength(HandName.highCard, <PokerRank>[]);
  }
}

HandStrengthChecker gHandStrengthChecker =
    HandStrengthChecker(); // ToDo: Maybe not global?
