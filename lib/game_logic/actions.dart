import 'package:poker_game/game_store/playing_card.dart';

class ChangeNumberOfPlayersAction {
  final int numOfPlayers;
  ChangeNumberOfPlayersAction(this.numOfPlayers);
}

class StartOfflineGameAction {}

class ToggleSelectedCardAction {
  final PlayingCard selectedCard;
  ToggleSelectedCardAction(this.selectedCard);
}

class ReplaceCardsAction {}

class EndTurnAction {}
