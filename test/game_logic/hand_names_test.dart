import 'package:poker_game/game_logic/hand_names.dart';
import 'package:poker_game/game_store/playing_card.dart';
import 'package:test/test.dart';

class HandStrengthTester {
  final HandStrengthChecker handStrengthChecker = HandStrengthChecker();

  void test(List<PlayingCard> cards, HandName expectedHandName) {
    final HandStrength handStrength =
        handStrengthChecker.checkHandStrength(cards);
    expect(handStrength.handName, expectedHandName);
  }
}

void main() {
  final HandStrengthTester handStrengthTester = HandStrengthTester();
  group('Hand strength', () {
    test('Hand strength should be high card #1', () {
      final List<PlayingCard> cards = <PlayingCard>[
        PlayingCard(CardRank.two, CardColor.diamonds),
        PlayingCard(CardRank.three, CardColor.hearts),
        PlayingCard(CardRank.seven, CardColor.clubs),
        PlayingCard(CardRank.eight, CardColor.clubs),
        PlayingCard(CardRank.jack, CardColor.spades)
      ];
      handStrengthTester.test(cards, HandName.highCard);
    });
    test('Hand strength should be high card #2', () {
      final List<PlayingCard> cards = <PlayingCard>[
        PlayingCard(CardRank.four, CardColor.hearts),
        PlayingCard(CardRank.five, CardColor.hearts),
        PlayingCard(CardRank.eight, CardColor.clubs),
        PlayingCard(CardRank.nine, CardColor.clubs),
        PlayingCard(CardRank.ace, CardColor.clubs)
      ];
      handStrengthTester.test(cards, HandName.highCard);
    });
    test('Hand strength should be pair #1', () {
      final List<PlayingCard> cards = <PlayingCard>[
        PlayingCard(CardRank.three, CardColor.diamonds),
        PlayingCard(CardRank.three, CardColor.hearts),
        PlayingCard(CardRank.seven, CardColor.clubs),
        PlayingCard(CardRank.eight, CardColor.clubs),
        PlayingCard(CardRank.jack, CardColor.spades)
      ];
      handStrengthTester.test(cards, HandName.pair);
    });
    test('Hand strength should be pair #2', () {
      final List<PlayingCard> cards = <PlayingCard>[
        PlayingCard(CardRank.three, CardColor.diamonds),
        PlayingCard(CardRank.seven, CardColor.hearts),
        PlayingCard(CardRank.seven, CardColor.clubs),
        PlayingCard(CardRank.eight, CardColor.clubs),
        PlayingCard(CardRank.jack, CardColor.spades)
      ];
      handStrengthTester.test(cards, HandName.pair);
    });
    test('Hand strength should be pair #3', () {
      final List<PlayingCard> cards = <PlayingCard>[
        PlayingCard(CardRank.three, CardColor.diamonds),
        PlayingCard(CardRank.seven, CardColor.hearts),
        PlayingCard(CardRank.eight, CardColor.clubs),
        PlayingCard(CardRank.eight, CardColor.clubs),
        PlayingCard(CardRank.jack, CardColor.spades)
      ];
      handStrengthTester.test(cards, HandName.pair);
    });
    test('Hand strength should be pair #4', () {
      final List<PlayingCard> cards = <PlayingCard>[
        PlayingCard(CardRank.three, CardColor.diamonds),
        PlayingCard(CardRank.four, CardColor.hearts),
        PlayingCard(CardRank.seven, CardColor.clubs),
        PlayingCard(CardRank.jack, CardColor.clubs),
        PlayingCard(CardRank.jack, CardColor.spades)
      ];
      handStrengthTester.test(cards, HandName.pair);
    });
    test('Hand strength should be two pairs #1', () {
      final List<PlayingCard> cards = <PlayingCard>[
        PlayingCard(CardRank.three, CardColor.diamonds),
        PlayingCard(CardRank.three, CardColor.hearts),
        PlayingCard(CardRank.seven, CardColor.clubs),
        PlayingCard(CardRank.seven, CardColor.clubs),
        PlayingCard(CardRank.jack, CardColor.spades)
      ];
      handStrengthTester.test(cards, HandName.twoPairs);
    });
    test('Hand strength should be two pairs #2', () {
      final List<PlayingCard> cards = <PlayingCard>[
        PlayingCard(CardRank.five, CardColor.diamonds),
        PlayingCard(CardRank.six, CardColor.hearts),
        PlayingCard(CardRank.six, CardColor.clubs),
        PlayingCard(CardRank.nine, CardColor.clubs),
        PlayingCard(CardRank.nine, CardColor.spades)
      ];
      handStrengthTester.test(cards, HandName.twoPairs);
    });
    test('Hand strength should be two pairs #3', () {
      final List<PlayingCard> cards = <PlayingCard>[
        PlayingCard(CardRank.five, CardColor.diamonds),
        PlayingCard(CardRank.five, CardColor.spades),
        PlayingCard(CardRank.six, CardColor.hearts),
        PlayingCard(CardRank.jack, CardColor.clubs),
        PlayingCard(CardRank.jack, CardColor.hearts)
      ];
      handStrengthTester.test(cards, HandName.twoPairs);
    });
    test('Hand strength should be three of a kind #1', () {
      final List<PlayingCard> cards = <PlayingCard>[
        PlayingCard(CardRank.three, CardColor.spades),
        PlayingCard(CardRank.three, CardColor.hearts),
        PlayingCard(CardRank.three, CardColor.diamonds),
        PlayingCard(CardRank.six, CardColor.clubs),
        PlayingCard(CardRank.seven, CardColor.spades)
      ];
      handStrengthTester.test(cards, HandName.threeOfAKind);
    });
    test('Hand strength should be three of a kind #2', () {
      final List<PlayingCard> cards = <PlayingCard>[
        PlayingCard(CardRank.three, CardColor.diamonds),
        PlayingCard(CardRank.six, CardColor.hearts),
        PlayingCard(CardRank.six, CardColor.hearts),
        PlayingCard(CardRank.six, CardColor.clubs),
        PlayingCard(CardRank.seven, CardColor.spades)
      ];
      handStrengthTester.test(cards, HandName.threeOfAKind);
    });
    test('Hand strength should be three of a kind #3', () {
      final List<PlayingCard> cards = <PlayingCard>[
        PlayingCard(CardRank.three, CardColor.diamonds),
        PlayingCard(CardRank.six, CardColor.spades),
        PlayingCard(CardRank.eight, CardColor.hearts),
        PlayingCard(CardRank.eight, CardColor.clubs),
        PlayingCard(CardRank.eight, CardColor.clubs)
      ];
      handStrengthTester.test(cards, HandName.threeOfAKind);
    });
    test('Hand strength should be straight #1', () {
      final List<PlayingCard> cards = <PlayingCard>[
        PlayingCard(CardRank.three, CardColor.spades),
        PlayingCard(CardRank.four, CardColor.hearts),
        PlayingCard(CardRank.five, CardColor.diamonds),
        PlayingCard(CardRank.six, CardColor.clubs),
        PlayingCard(CardRank.seven, CardColor.spades)
      ];
      handStrengthTester.test(cards, HandName.straight);
    });
    test('Hand strength should be straight #2', () {
      final List<PlayingCard> cards = <PlayingCard>[
        PlayingCard(CardRank.ace, CardColor.diamonds),
        PlayingCard(CardRank.two, CardColor.hearts),
        PlayingCard(CardRank.three, CardColor.diamonds),
        PlayingCard(CardRank.four, CardColor.hearts),
        PlayingCard(CardRank.five, CardColor.spades)
      ];
      handStrengthTester.test(cards, HandName.straight);
    });
    test('Hand strength should be flush #1', () {
      final List<PlayingCard> cards = <PlayingCard>[
        PlayingCard(CardRank.three, CardColor.spades),
        PlayingCard(CardRank.six, CardColor.spades),
        PlayingCard(CardRank.seven, CardColor.spades),
        PlayingCard(CardRank.queen, CardColor.spades),
        PlayingCard(CardRank.king, CardColor.spades)
      ];
      handStrengthTester.test(cards, HandName.flush);
    });
    test('Hand strength should be flush #2', () {
      final List<PlayingCard> cards = <PlayingCard>[
        PlayingCard(CardRank.two, CardColor.clubs),
        PlayingCard(CardRank.five, CardColor.clubs),
        PlayingCard(CardRank.seven, CardColor.clubs),
        PlayingCard(CardRank.jack, CardColor.clubs),
        PlayingCard(CardRank.ace, CardColor.clubs)
      ];
      handStrengthTester.test(cards, HandName.flush);
    });
    test('Hand strength should be full house #1', () {
      final List<PlayingCard> cards = <PlayingCard>[
        PlayingCard(CardRank.jack, CardColor.hearts),
        PlayingCard(CardRank.jack, CardColor.clubs),
        PlayingCard(CardRank.ace, CardColor.diamonds),
        PlayingCard(CardRank.ace, CardColor.clubs),
        PlayingCard(CardRank.ace, CardColor.spades)
      ];
      handStrengthTester.test(cards, HandName.fullHouse);
    });
    test('Hand strength should be full house #2', () {
      final List<PlayingCard> cards = <PlayingCard>[
        PlayingCard(CardRank.three, CardColor.hearts),
        PlayingCard(CardRank.three, CardColor.clubs),
        PlayingCard(CardRank.three, CardColor.diamonds),
        PlayingCard(CardRank.four, CardColor.clubs),
        PlayingCard(CardRank.four, CardColor.spades)
      ];
      handStrengthTester.test(cards, HandName.fullHouse);
    });
    test('Hand strength should be four of a kind #1', () {
      final List<PlayingCard> cards = <PlayingCard>[
        PlayingCard(CardRank.two, CardColor.hearts),
        PlayingCard(CardRank.four, CardColor.clubs),
        PlayingCard(CardRank.four, CardColor.diamonds),
        PlayingCard(CardRank.four, CardColor.clubs),
        PlayingCard(CardRank.four, CardColor.spades)
      ];
      handStrengthTester.test(cards, HandName.fourOfAKind);
    });
    test('Hand strength should be four of a kind #2', () {
      final List<PlayingCard> cards = <PlayingCard>[
        PlayingCard(CardRank.nine, CardColor.hearts),
        PlayingCard(CardRank.nine, CardColor.clubs),
        PlayingCard(CardRank.nine, CardColor.diamonds),
        PlayingCard(CardRank.nine, CardColor.clubs),
        PlayingCard(CardRank.jack, CardColor.spades)
      ];
      handStrengthTester.test(cards, HandName.fourOfAKind);
    });

    test('Hand strength should be Poker #1', () {
      final List<PlayingCard> cards = <PlayingCard>[
        PlayingCard(CardRank.three, CardColor.diamonds),
        PlayingCard(CardRank.four, CardColor.diamonds),
        PlayingCard(CardRank.five, CardColor.diamonds),
        PlayingCard(CardRank.six, CardColor.diamonds),
        PlayingCard(CardRank.seven, CardColor.diamonds)
      ];
      handStrengthTester.test(cards, HandName.poker);
    });

    test('Hand strength should be poker #2', () {
      final List<PlayingCard> cards = <PlayingCard>[
        PlayingCard(CardRank.ten, CardColor.clubs),
        PlayingCard(CardRank.jack, CardColor.clubs),
        PlayingCard(CardRank.queen, CardColor.clubs),
        PlayingCard(CardRank.king, CardColor.clubs),
        PlayingCard(CardRank.ace, CardColor.clubs)
      ];
      handStrengthTester.test(cards, HandName.poker);
    });
    test('Hand strength should be poker #3', () {
      final List<PlayingCard> cards = <PlayingCard>[
        PlayingCard(CardRank.ace, CardColor.hearts),
        PlayingCard(CardRank.two, CardColor.hearts),
        PlayingCard(CardRank.three, CardColor.hearts),
        PlayingCard(CardRank.four, CardColor.hearts),
        PlayingCard(CardRank.five, CardColor.hearts)
      ];
      handStrengthTester.test(cards, HandName.poker);
    });
  });
}
