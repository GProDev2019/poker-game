import 'package:poker_game/poker_game_store/poker_game_state.dart';
import 'package:poker_game/poker_game_store/poker_card.dart';
import 'package:poker_game/poker_game_store/poker_hand.dart';
import 'actions.dart';

PokerGameState dispatchPokerGameAction(PokerGameState state, dynamic action) {
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

PokerGameState _changeNumberOfPlayers(
    PokerGameState state, ChangeNumberOfPlayersAction action) {
  state.numOfPlayers = action.numOfPlayers;
  return state;
}

PokerGameState _startOfflineGame(PokerGameState state) {
  state = _shuffleDeck(state);
  state = _handOutCardsToPlayers(state);
  return state;
}

PokerGameState _shuffleDeck(PokerGameState state) {
  state.deck.cards.shuffle();
  return state;
}

PokerGameState _handOutCardsToPlayers(PokerGameState state) {
  if (HandOutStrategy.allCardsAtOnce == state.handOutStrategy) {
    state = _allCardsAtOnceHandOutStrategy(state);
  } else if (HandOutStrategy.oneByOneCard == state.handOutStrategy) {
    state = _oneByOneCardHandOutStrategy(state);
  }
  state = _sortPlayersCards(state);
  return state;
}

PokerGameState _allCardsAtOnceHandOutStrategy(PokerGameState state) {
  for (int playerIndex = 0; playerIndex < state.players.length; playerIndex++) {
    for (int cardNum = 0; cardNum < PokerHand.maxNumOfCards; cardNum++) {
      state = _handOutCardToPlayer(state, playerIndex);
    }
  }
  return state;
}

PokerGameState _oneByOneCardHandOutStrategy(PokerGameState state) {
  for (int cardNum = 0; cardNum < PokerHand.maxNumOfCards; cardNum++) {
    for (int playerIndex = 0;
        playerIndex < state.players.length;
        playerIndex++) {
      state = _handOutCardToPlayer(state, playerIndex);
    }
  }
  return state;
}

PokerGameState _handOutCardToPlayer(PokerGameState state, int playerIndex) {
  state.players[playerIndex].hand.cards.add(state.deck.cards.removeLast());
  return state;
}

PokerGameState _sortPlayersCards(PokerGameState state) {
  for (int playerIndex = 0; playerIndex < state.numOfPlayers; playerIndex++) {
    state.players[playerIndex].hand.cards
        .sort((PokerCard lCard, PokerCard rCard) => lCard.compareTo(rCard));
  }
  return state;
}

PokerGameState _selectCard(PokerGameState state, SelectCardAction action) {
  state.players[state.currentPlayer].hand.cards
      .firstWhere((PokerCard card) =>
          card.color == action.selectedCard.color &&
          card.index == action.selectedCard.index)
      .selectedForReplace = true;
  return state;
}

PokerGameState _unselectCard(PokerGameState state, UnselectCardAction action) {
  state.players[state.currentPlayer].hand.cards
      .firstWhere((PokerCard card) =>
          card.color == action.unselectedCard.color &&
          card.index == action.unselectedCard.index)
      .selectedForReplace = false;
  return state;
}

PokerGameState _replaceCards(PokerGameState state) {
  final int numOfCardsToReplace = state.players[state.currentPlayer].hand.cards
      .where((PokerCard card) => card.selectedForReplace)
      .length;
  state.players[state.currentPlayer].hand.cards
      .removeWhere((PokerCard card) => card.selectedForReplace);
  for (int cardNum = 0; cardNum < numOfCardsToReplace; cardNum++) {
    state = _handOutCardToPlayer(state, state.currentPlayer);
  }
  return state;
}

PokerGameState _endTurn(PokerGameState state) {
  if (++state.currentPlayer == state.numOfPlayers) {
    state = _endGame(state);
  }
  return state;
}

PokerGameState _endGame(PokerGameState state) {
  state = _compareHands(state);
  state.gameEnded = true;
  return state;
}

PokerGameState _compareHands(PokerGameState state) {
  return state;
}
