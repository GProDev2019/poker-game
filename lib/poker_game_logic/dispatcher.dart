import 'package:poker_game/poker_game_store/poker_game_state.dart';
import '../poker_game_store/poker_hand.dart';
import 'actions.dart';

PokerGameState dispatchPokerGameAction(PokerGameState state, dynamic action) {
  if (action is StartOfflineGameAction) {
    return _startOfflineGame(state);
  } else if (action is SelectCardAction) {
    return _selectCard(state, action);
  } else if (action is ReplaceCardsAction) {
    return _replaceCards(state, action);
  }
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

PokerGameState _selectCard(PokerGameState state, SelectCardAction action) {
  // ToDo
  return state;
}

PokerGameState _replaceCards(PokerGameState state, ReplaceCardsAction action) {
  // ToDo
  return state;
}
