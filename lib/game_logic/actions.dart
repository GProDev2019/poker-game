import 'package:poker_game/game_store/playing_card.dart';

class ChangeNumberOfPlayersAction {
  final int numOfPlayers;
  ChangeNumberOfPlayersAction(this.numOfPlayers);
}

class StartOfflineGameAction {}

class SelectCardAction {
  final PlayingCard selectedCard;
  SelectCardAction(this.selectedCard);
}

class UnselectCardAction {
  final PlayingCard unselectedCard;
  UnselectCardAction(this.unselectedCard);
}

class ReplaceCardsAction {}

class EndTurnAction {}
