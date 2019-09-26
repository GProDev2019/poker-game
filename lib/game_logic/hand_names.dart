import 'package:poker_game/game_store/playing_card.dart';

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
  List<CardRank> cardRanks;
  HandStrength(this.handName, this.cardRanks);

  // ToDo: Implement comparator
}

class HandStrengthChecker {
  List<PlayingCard> _cards;
  HandStrength checkHandStrength(List<PlayingCard> cards) {
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
    return HandStrength(HandName.poker, <CardRank>[_cards.last.rank]);
  }

  HandStrength _isFourOfAKind() {
    // ToDo
    return HandStrength(HandName.fourOfAKind, <CardRank>[]);
  }

  HandStrength _isFullHouse() {
    // ToDo
    return HandStrength(HandName.fullHouse, <CardRank>[]);
  }

  HandStrength _isFlush() {
    // ToDo
    return HandStrength(HandName.flush, <CardRank>[]);
  }

  HandStrength _isStraight() {
    // ToDo
    return HandStrength(HandName.straight, <CardRank>[]);
  }

  HandStrength _isThreeOfAKind() {
    // ToDo
    return HandStrength(HandName.threeOfAKind, <CardRank>[]);
  }

  HandStrength _isTwoPairs() {
    // ToDo
    return HandStrength(HandName.twoPairs, <CardRank>[]);
  }

  HandStrength _isPair() {
    // ToDo
    return HandStrength(HandName.pair, <CardRank>[]);
  }

  HandStrength _isHighCard() {
    // ToDo
    return HandStrength(HandName.highCard, <CardRank>[]);
  }
}

HandStrengthChecker gHandStrengthChecker =
    HandStrengthChecker(); // ToDo: Maybe not global?
