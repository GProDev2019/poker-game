import 'package:poker_game/poker_game_store/poker_card.dart';

class StartOfflineGameAction {}

class SelectCardAction {
  final PokerCard selectedCard;
  SelectCardAction(this.selectedCard);
}

class ReplaceCardsAction {
  final int playerIndex;
  final List<PokerCard> cardsToReplace;
  ReplaceCardsAction(this.playerIndex, this.cardsToReplace);
}
