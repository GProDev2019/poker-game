import 'package:poker_game/game_store/card_info.dart';
import 'package:poker_game/game_store/playing_card.dart';

import 'hand_name.dart';
import 'hand_strength.dart';

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

  List<CardRank> _getCardRankList() {
    return List<CardRank>.generate(
        _cards.length, (int index) => _cards[index].rank);
  }

  HandStrength _isPoker() {
    // Check for whell
    if (_cards[0].rank == CardRank.ace &&
        _cards[1].rank == CardRank.two &&
        _cards[2].rank == CardRank.three &&
        _cards[3].rank == CardRank.four &&
        _cards[4].rank == CardRank.five) {
      for (int cardNum = 0; cardNum < _cards.length - 1; cardNum++) {
        if ((_cards[cardNum].color.index) != _cards[cardNum + 1].color.index) {
          return null;
        }
      }
      return HandStrength(HandName.poker, _getCardRankList());
    }
    // Check rest
    for (int cardNum = 0; cardNum < _cards.length - 1; cardNum++) {
      if (((_cards[cardNum].rank.index + 1) !=
              _cards[cardNum + 1].rank.index) ||
          ((_cards[cardNum].color.index) != _cards[cardNum + 1].color.index)) {
        return null;
      }
    }
    return HandStrength(HandName.poker, _getCardRankList());
  }

  HandStrength _isFourOfAKind() {
    if (_cards
        .sublist(0, 4)
        .every((PlayingCard card) => card.rank.index == _cards[0].rank.index)) {
      return HandStrength(HandName.fourOfAKind, <CardRank>[_cards[0].rank]);
    } else if (_cards
        .sublist(1, 5)
        .every((PlayingCard card) => card.rank.index == _cards[1].rank.index)) {
      return HandStrength(HandName.fourOfAKind, <CardRank>[_cards[1].rank]);
    }
    return null;
  }

  HandStrength _isFullHouse() {
    if (_cards.sublist(0, 3).every(
            (PlayingCard card) => card.rank.index == _cards[0].rank.index) &&
        _cards.sublist(3, 5).every(
            (PlayingCard card) => card.rank.index == _cards[3].rank.index)) {
      return HandStrength(
          HandName.fullHouse, <CardRank>[_cards[3].rank, _cards[0].rank]);
    } else if (_cards.sublist(0, 2).every(
            (PlayingCard card) => card.rank.index == _cards[0].rank.index) &&
        _cards.sublist(2, 5).every(
            (PlayingCard card) => card.rank.index == _cards[2].rank.index)) {
      return HandStrength(
          HandName.fullHouse, <CardRank>[_cards[0].rank, _cards[2].rank]);
    }
    return null;
  }

  HandStrength _isFlush() {
    if (_cards.every(
        (PlayingCard card) => card.color.index == _cards[0].color.index)) {
      return HandStrength(HandName.flush, _getCardRankList());
    }
    return null;
  }

  HandStrength _isStraight() {
    // Check for whell
    if (_cards[0].rank == CardRank.ace &&
        _cards[1].rank == CardRank.two &&
        _cards[2].rank == CardRank.three &&
        _cards[3].rank == CardRank.four &&
        _cards[4].rank == CardRank.five) {
      return HandStrength(HandName.straight, _getCardRankList());
    }
    // Check rest
    for (int cardNum = 0; cardNum < _cards.length - 1; cardNum++) {
      if (_cards[cardNum].rank.index + 1 != _cards[cardNum + 1].rank.index) {
        return null;
      }
    }
    return HandStrength(HandName.straight, _getCardRankList());
  }

  HandStrength _isThreeOfAKind() {
    if (_cards
        .sublist(0, 3)
        .every((PlayingCard card) => card.rank.index == _cards[0].rank.index)) {
      return HandStrength(HandName.threeOfAKind, <CardRank>[_cards[0].rank]);
    } else if (_cards
        .sublist(1, 4)
        .every((PlayingCard card) => card.rank.index == _cards[1].rank.index)) {
      return HandStrength(HandName.threeOfAKind, <CardRank>[_cards[1].rank]);
    } else if (_cards
        .sublist(2, 5)
        .every((PlayingCard card) => card.rank.index == _cards[2].rank.index)) {
      return HandStrength(HandName.threeOfAKind, <CardRank>[_cards[2].rank]);
    }
    return null;
  }

  HandStrength _isTwoPairs() {
    int pairs = 0;
    final List<CardRank> foundPairsRank = <CardRank>[];
    for (int cardNum = 0; cardNum < _cards.length - 1; cardNum++) {
      if (_cards.sublist(cardNum, cardNum + 2).every((PlayingCard card) =>
          card.rank.index == _cards[cardNum].rank.index)) {
        foundPairsRank.add(_cards[cardNum].rank);
        pairs++;
        cardNum++;
      }
    }
    if (pairs == 2) {
      return HandStrength(HandName.twoPairs, _getCardRankList(),
          foundPairsRank[1], foundPairsRank[0]);
    }
    return null;
  }

  HandStrength _isPair() {
    for (int cardNum = 0; cardNum < _cards.length - 1; cardNum++) {
      if (_cards.sublist(cardNum, cardNum + 2).every((PlayingCard card) =>
          card.rank.index == _cards[cardNum].rank.index)) {
        return HandStrength(
            HandName.pair, _getCardRankList(), _cards[cardNum].rank);
      }
    }
    return null;
  }

  HandStrength _isHighCard() {
    return HandStrength(HandName.highCard, _getCardRankList());
  }
}
