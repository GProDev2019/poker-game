import 'package:poker_game/poker_game_store/poker_card.dart';

class ChangeNumberOfPlayersAction {
  final int numOfPlayers;
  ChangeNumberOfPlayersAction(this.numOfPlayers);
}

class StartOfflineGameAction {}

class SelectCardAction {
  final PokerCard selectedCard;
  SelectCardAction(this.selectedCard);
}

class UnselectCardAction {
  final PokerCard unselectedCard;
  UnselectCardAction(this.unselectedCard);
}

class ReplaceCardsAction {}

class EndTurnAction {}
