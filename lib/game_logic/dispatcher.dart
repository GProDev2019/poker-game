import 'package:poker_game/game_store/game_state.dart';
import 'package:poker_game/game_store/playing_card.dart';
import 'package:poker_game/game_store/hand.dart';
import 'package:poker_game/game_store/player.dart';
import 'actions.dart';
import 'hand_names.dart';

GameState dispatchPokerGameAction(GameState state, dynamic action) {
  if (action is ChangeNumberOfPlayersAction) {
    return _changeNumberOfPlayers(state, action);
  } else if (action is StartOfflineGameAction) {
    return _startOfflineGame(state);
  } else if (action is SelectCardAction) {
    return _selectCard(state, action);
  } else if (action is UnselectCardAction) {
    return _unselectCard(state, action);
  } else if (action is ReplaceCardsAction) {
    return _replaceCards(state);
  } else if (action is EndTurnAction) {
    return _endTurn(state);
  }
  return state;
}

GameState _changeNumberOfPlayers(
    GameState state, ChangeNumberOfPlayersAction action) {
  state.numOfPlayers = action.numOfPlayers;
  return state;
}

GameState _startOfflineGame(GameState state) {
  state = _shuffleDeck(state);
  state = _handOutCardsToPlayers(state);
  return state;
}

GameState _shuffleDeck(GameState state) {
  state.deck.cards.shuffle();
  return state;
}

GameState _handOutCardsToPlayers(GameState state) {
  if (HandOutStrategy.allCardsAtOnce == state.handOutStrategy) {
    state = _allCardsAtOnceHandOutStrategy(state);
  } else if (HandOutStrategy.oneByOneCard == state.handOutStrategy) {
    state = _oneByOneCardHandOutStrategy(state);
  }
  state = _sortPlayersCards(state);
  return state;
}

GameState _allCardsAtOnceHandOutStrategy(GameState state) {
  for (int playerIndex = 0; playerIndex < state.players.length; playerIndex++) {
    for (int cardNum = 0; cardNum < Hand.maxNumOfCards; cardNum++) {
      state = _handOutCardToPlayer(state, playerIndex);
    }
  }
  return state;
}

GameState _oneByOneCardHandOutStrategy(GameState state) {
  for (int cardNum = 0; cardNum < Hand.maxNumOfCards; cardNum++) {
    for (int playerIndex = 0;
        playerIndex < state.players.length;
        playerIndex++) {
      state = _handOutCardToPlayer(state, playerIndex);
    }
  }
  return state;
}

GameState _handOutCardToPlayer(GameState state, int playerIndex) {
  state.players[playerIndex].hand.cards.add(state.deck.cards.removeLast());
  return state;
}

GameState _sortPlayersCards(GameState state) {
  for (int playerIndex = 0; playerIndex < state.numOfPlayers; playerIndex++) {
    state = _sortPlayerCards(state, playerIndex);
  }
  return state;
}

GameState _sortPlayerCards(GameState state, int playerIndex) {
  state.players[playerIndex].hand.cards
      .sort((PlayingCard lCard, PlayingCard rCard) => lCard.compareTo(rCard));
  return state;
}

GameState _selectCard(GameState state, SelectCardAction action) {
  state.players[state.currentPlayer].hand.cards
      .firstWhere((PlayingCard card) =>
          card.color == action.selectedCard.color &&
          card.rank == action.selectedCard.rank)
      .selectedForReplace = true;
  return state;
}

GameState _unselectCard(GameState state, UnselectCardAction action) {
  state.players[state.currentPlayer].hand.cards
      .firstWhere((PlayingCard card) =>
          card.color == action.unselectedCard.color &&
          card.rank == action.unselectedCard.rank)
      .selectedForReplace = false;
  return state;
}

GameState _replaceCards(GameState state) {
  final int numOfCardsToReplace = state.players[state.currentPlayer].hand.cards
      .where((PlayingCard card) => card.selectedForReplace)
      .length;
  state.players[state.currentPlayer].hand.cards
      .removeWhere((PlayingCard card) => card.selectedForReplace);
  for (int cardNum = 0; cardNum < numOfCardsToReplace; cardNum++) {
    state = _handOutCardToPlayer(state, state.currentPlayer);
  }
  _sortPlayerCards(state, state.currentPlayer);
  return state;
}

GameState _endTurn(GameState state) {
  if (++state.currentPlayer == state.numOfPlayers) {
    state = _endGame(state);
  }
  return state;
}

GameState _endGame(GameState state) {
  state = _compareHands(state);
  state.gameEnded = true;
  return state;
}

GameState _compareHands(GameState state) {
  final List<HandStrength> playersHandStrength = <HandStrength>[];
  for (Player player in state.players) {
    playersHandStrength
        .add(gHandStrengthChecker.checkHandStrength(player.hand.cards));
  }
  playersHandStrength.sort();
  return state;
}
