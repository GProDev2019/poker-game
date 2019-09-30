import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:poker_game/game_store/game_state.dart';
import 'package:poker_game/game_store/playing_card.dart';
import 'package:poker_game/game_store/hand.dart';
import 'package:poker_game/game_store/player.dart';
import 'actions.dart';
import 'hand_names.dart';

class Dispatcher {
  final HandStrengthChecker _handStrengthChecker = HandStrengthChecker();

  GameState dispatchPokerGameAction(GameState state, dynamic action) {
    switch (action.runtimeType) {
      case NavigateToAction:
        return state;
      case ChangeNumberOfPlayersAction:
        return _changeNumberOfPlayers(state, action);
      case StartOfflineGameAction:
        return _startOfflineGame(state);
      case ToggleSelectedCardAction:
        return _toggleCard(state, action);
      case ReplaceCardsAction:
        return _replaceCards(state);
      case EndTurnAction:
        return _endTurn(state);
      case BackToMenuAction:
        return _backToMenu(state);
      default:
        throw "Unhandled action or state didn't change (Reducer shouldn't return the same state), action: ${action.toString()}";
    }
  }

  GameState _changeNumberOfPlayers(
      GameState state, ChangeNumberOfPlayersAction action) {
    state.numOfPlayers = action.numOfPlayers;
    state.players = List<Player>.generate(
        state.numOfPlayers, (int index) => Player(index),
        growable: false);
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
    for (int playerIndex = 0;
        playerIndex < state.players.length;
        playerIndex++) {
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

  GameState _toggleCard(GameState state, ToggleSelectedCardAction action) {
    state.players[state.currentPlayer].hand.cards
        .firstWhere((PlayingCard card) =>
            card.color == action.selectedCard.color &&
            card.rank == action.selectedCard.rank)
        .selectedForReplace = !action.selectedCard.selectedForReplace;
    return state;
  }

  GameState _replaceCards(GameState state) {
    final int numOfCardsToReplace = state
        .players[state.currentPlayer].hand.cards
        .where((PlayingCard card) => card.selectedForReplace)
        .length;
    state.players[state.currentPlayer].hand.cards
        .removeWhere((PlayingCard card) => card.selectedForReplace);
    for (int cardNum = 0; cardNum < numOfCardsToReplace; cardNum++) {
      state = _handOutCardToPlayer(state, state.currentPlayer);
    }
    _sortPlayerCards(state, state.currentPlayer);
    state.players[state.currentPlayer].replacedCards = true;
    return state;
  }

  GameState _endTurn(GameState state) {
    if (state.currentPlayer == state.numOfPlayers - 1) {
      state = _endGame(state);
    } else {
      state.currentPlayer += 1;
    }
    return state;
  }

  GameState _endGame(GameState state) {
    state = _calculateHands(state);
    state.gameEnded = true;
    return state;
  }

  GameState _calculateHands(GameState state) {
    for (Player player in state.players) {
      player.handStrength =
          _handStrengthChecker.checkHandStrength(player.hand.cards);
    }
    return state;
  }

  GameState _backToMenu(GameState state) {
    state = GameState.initial();
    return state;
  }
}
