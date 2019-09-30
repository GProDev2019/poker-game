import 'package:json_annotation/json_annotation.dart';
import 'package:poker_game/game_store/card_info.dart';
import 'package:poker_game/game_store/playing_card.dart';

import 'hand_name.dart';

part 'hand_strength.g.dart';

@JsonSerializable()
class HandStrength implements Comparable<HandStrength> {
  HandName handName;
  CardRank higherCardRank;
  CardRank lowerCardRank;
  List<CardRank> cardRanks;
  HandStrength(this.handName, this.cardRanks,
      [this.higherCardRank, this.lowerCardRank]);

  @override
  int compareTo(HandStrength otherHandStrength) {
    if (handName.index > otherHandStrength.handName.index) {
      return -1;
    } else if (handName.index == otherHandStrength.handName.index) {
      return _checkStrengthWhenEqual(otherHandStrength);
    } else {
      return 1;
    }
  }

  int _checkStrengthWhenEqual(HandStrength otherHandStrength) {
    switch (handName) {
      case HandName.highCard:
      case HandName.straight:
      case HandName.flush:
      case HandName.poker:
      case HandName.threeOfAKind:
      case HandName.fourOfAKind:
      case HandName.fullHouse:
        for (int i = cardRanks.length - 1; i >= 0; i--) {
          if (cardRanks[i].index > otherHandStrength.cardRanks[i].index) {
            return -1;
          } else if (cardRanks[i].index <
              otherHandStrength.cardRanks[i].index) {
            return 1;
          }
        }
        return 0;
      case HandName.pair:
        if (higherCardRank.index > otherHandStrength.higherCardRank.index) {
          return -1;
        } else if (higherCardRank.index <
            otherHandStrength.higherCardRank.index) {
          return 1;
        }
        final List<CardRank> leftCardRanks =
            cardRanks.where((CardRank card) => card != higherCardRank).toList();
        final List<CardRank> rightCardRanks = otherHandStrength.cardRanks
            .where((CardRank card) => card != higherCardRank)
            .toList();
        for (int i = leftCardRanks.length - 1; i >= 0; i--) {
          if (leftCardRanks[i].index > rightCardRanks[i].index) {
            return -1;
          } else if (leftCardRanks[i].index < rightCardRanks[i].index) {
            return 1;
          }
        }
        return 0;
      case HandName.twoPairs:
        if (higherCardRank.index > otherHandStrength.higherCardRank.index) {
          return -1;
        } else if (higherCardRank.index <
            otherHandStrength.higherCardRank.index) {
          return 1;
        }
        if (lowerCardRank.index > otherHandStrength.lowerCardRank.index) {
          return -1;
        } else if (lowerCardRank.index <
            otherHandStrength.lowerCardRank.index) {
          return 1;
        }
        final List<CardRank> leftCardRanks = cardRanks
            .where((CardRank card) =>
                card != higherCardRank && card != lowerCardRank)
            .toList();
        final List<CardRank> rightCardRanks = otherHandStrength.cardRanks
            .where((CardRank card) =>
                card != higherCardRank && card != lowerCardRank)
            .toList();
        for (int i = leftCardRanks.length - 1; i >= 0; i--) {
          if (leftCardRanks[i].index > rightCardRanks[i].index) {
            return -1;
          } else if (leftCardRanks[i].index < rightCardRanks[i].index) {
            return 1;
          }
        }
        return 0;
      default:
        throw 'Something is wrong with players hands as comparison of these two is not supported. First player: $handName, Second player: ${otherHandStrength.handName}';
    }
  }

  factory HandStrength.fromJson(Map<String, dynamic> json) =>
      _$HandStrengthFromJson(json);

  Map<String, dynamic> toJson() => _$HandStrengthToJson(this);
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
