import 'package:poker_game/game_store/game_state.dart';
import 'package:poker_game/game_store/playing_card.dart';

class ChangeNumberOfPlayersAction {
  final int numOfPlayers;
  ChangeNumberOfPlayersAction(this.numOfPlayers)
      : assert(GameState.minNumOfPlayers <= numOfPlayers &&
            numOfPlayers <= GameState.maxNumOfPlayers);
}

class StartOfflineGameAction {}

class ToggleSelectedCardAction {
  final PlayingCard selectedCard;
  ToggleSelectedCardAction(this.selectedCard);
}

class ReplaceCardsAction {}

class EndTurnAction {}

class BackToMenuAction {}
