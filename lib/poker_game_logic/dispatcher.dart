import 'package:poker_game/poker_game_store/poker_game_state.dart';
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
  // ToDo
  return state;
}

PokerGameState _shuffleDeck(PokerGameState state) {
  state.deck.cards.shuffle();
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
