import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:poker_game/game_store/game_state.dart';
import 'package:poker_game/game_store/game_store.dart';
import 'package:poker_game/game_store/playing_card.dart';
import 'package:poker_game/game_store/hand.dart';
import 'package:poker_game/game_store/player.dart';
import 'actions.dart';
import 'hand_names.dart';

class Dispatcher {
  final HandStrengthChecker _handStrengthChecker = HandStrengthChecker();

  GameStore dispatchPokerGameAction(GameStore store, dynamic action) {
    switch (action.runtimeType) {
      case NavigateToAction:
        return store;
      case StartOfflineGameAction:
        return _startOfflineGame(store, action);
      case StartOnlineGameAction:
        return _startOnlineGame(store);
      case LoadRoomsAction:
        return _loadRooms(store, action);
      case EnterRoomAction:
        return _enterRoom(store, action);
      case ExitRoomAction:
        return _exitRoom(store);
      case ToggleSelectedCardAction:
        return _toggleCard(store, action);
      case ReplaceCardsAction:
        return _replaceCards(store);
      case EndTurnAction:
        return _endTurn(store);
      case BackToMenuAction:
        return _backToMenu(store);
      default:
        print(
            "Unhandled action or store didn't change (Reducer shouldn't return the same store), action: ${action.toString()}");
    }
    return store;
  }

  GameStore _updateNumberOfPlayers(GameStore store, int newNumofPlayers) {
    store.gameState.players = List<Player>.generate(
        newNumofPlayers, (int index) => Player(index),
        growable: false);
    return store;
  }

  GameStore _startOfflineGame(GameStore store, StartOfflineGameAction action) {
    store = _updateNumberOfPlayers(store, action.numOfPlayers);
    store = _shuffleDeck(store);
    store = _handOutCardsToPlayers(store);
    return store;
  }

  GameStore _startOnlineGame(GameStore store) {
    store = _shuffleDeck(store);
    store = _handOutCardsToPlayers(store);
    return store;
  }

  GameStore _loadRooms(GameStore store, LoadRoomsAction action) {
    store.rooms = action.rooms;
    return store;
  }

  GameStore _enterRoom(GameStore store, EnterRoomAction action) {
    store.currentRoom = action.roomId;
    if (store.rooms[action.roomId].gameState == null) {
      store.rooms[action.roomId].gameState = store.gameState;
    }
    store.gameState.currentPlayer =
        store.rooms[action.roomId].gameState.players.length;
    store.rooms[action.roomId].gameState.players
        .add(Player(store.rooms[action.roomId].gameState.players.length));
    return store;
  }

  GameStore _exitRoom(GameStore store) {
    store.rooms[store.currentRoom].gameState.players
        .removeWhere((Player player) {
      return player.playerIndex == store.gameState.currentPlayer;
    });
    return store;
  }

  GameStore _shuffleDeck(GameStore store) {
    store.gameState.deck.cards.shuffle();
    return store;
  }

  GameStore _handOutCardsToPlayers(GameStore store) {
    if (HandOutStrategy.allCardsAtOnce == store.gameState.handOutStrategy) {
      store = _allCardsAtOnceHandOutStrategy(store);
    } else if (HandOutStrategy.oneByOneCard ==
        store.gameState.handOutStrategy) {
      store = _oneByOneCardHandOutStrategy(store);
    }
    store = _sortPlayersCards(store);
    return store;
  }

  GameStore _allCardsAtOnceHandOutStrategy(GameStore store) {
    for (int playerIndex = 0;
        playerIndex < store.gameState.players.length;
        playerIndex++) {
      for (int cardNum = 0; cardNum < Hand.maxNumOfCards; cardNum++) {
        store = _handOutCardToPlayer(store, playerIndex);
      }
    }
    return store;
  }

  GameStore _oneByOneCardHandOutStrategy(GameStore store) {
    for (int cardNum = 0; cardNum < Hand.maxNumOfCards; cardNum++) {
      for (int playerIndex = 0;
          playerIndex < store.gameState.players.length;
          playerIndex++) {
        store = _handOutCardToPlayer(store, playerIndex);
      }
    }
    return store;
  }

  GameStore _handOutCardToPlayer(GameStore store, int playerIndex) {
    store.gameState.players[playerIndex].hand.cards
        .add(store.gameState.deck.cards.removeLast());
    return store;
  }

  GameStore _sortPlayersCards(GameStore store) {
    for (int playerIndex = 0;
        playerIndex < store.gameState.players.length;
        playerIndex++) {
      store = _sortPlayerCards(store, playerIndex);
    }
    return store;
  }

  GameStore _sortPlayerCards(GameStore store, int playerIndex) {
    store.gameState.players[playerIndex].hand.cards
        .sort((PlayingCard lCard, PlayingCard rCard) => lCard.compareTo(rCard));
    return store;
  }

  GameStore _toggleCard(GameStore store, ToggleSelectedCardAction action) {
    store.gameState.players[store.gameState.currentPlayer].hand.cards
        .firstWhere((PlayingCard card) =>
            card.color == action.selectedCard.color &&
            card.rank == action.selectedCard.rank)
        .selectedForReplace = !action.selectedCard.selectedForReplace;
    return store;
  }

  GameStore _replaceCards(GameStore store) {
    final int numOfCardsToReplace = store
        .gameState.players[store.gameState.currentPlayer].hand.cards
        .where((PlayingCard card) => card.selectedForReplace)
        .length;
    store.gameState.players[store.gameState.currentPlayer].hand.cards
        .removeWhere((PlayingCard card) => card.selectedForReplace);
    for (int cardNum = 0; cardNum < numOfCardsToReplace; cardNum++) {
      store = _handOutCardToPlayer(store, store.gameState.currentPlayer);
    }
    _sortPlayerCards(store, store.gameState.currentPlayer);
    store.gameState.players[store.gameState.currentPlayer].replacedCards = true;
    return store;
  }

  GameStore _endTurn(GameStore store) {
    if (store.gameState.currentPlayer == store.gameState.players.length - 1) {
      store = _endGame(store);
    } else {
      store.gameState.currentPlayer += 1;
    }
    return store;
  }

  GameStore _endGame(GameStore store) {
    store = _calculateHands(store);
    store.gameState.gameEnded = true;
    return store;
  }

  GameStore _calculateHands(GameStore store) {
    for (Player player in store.gameState.players) {
      player.handStrength =
          _handStrengthChecker.checkHandStrength(player.hand.cards);
    }
    return store;
  }

  GameStore _backToMenu(GameStore store) {
    store = GameStore.initial();
    return store;
  }
}
