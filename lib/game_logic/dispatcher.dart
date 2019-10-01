import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:poker_game/game_logic/hand_strength_checker.dart';
import 'package:poker_game/game_store/game_state.dart';
import 'package:poker_game/game_store/game_store.dart';
import 'package:poker_game/game_store/playing_card.dart';
import 'package:poker_game/game_store/hand.dart';
import 'package:poker_game/game_store/player.dart';
import 'package:poker_game/middleware/room.dart';
import 'actions.dart';

class Dispatcher {
  final HandStrengthChecker _handStrengthChecker = HandStrengthChecker();
  GameStore _store;
  GameState _state;

  GameStore dispatchPokerGameAction(GameStore store, dynamic action) {
    // Actions that doesn't change game state
    switch (action.runtimeType) {
      case LoadRoomsAction:
        return _loadRooms(store, action);
      case NavigateToAction:
        return store;
    }
    // Actions that change game state
    _store = store;
    _state = getGameState(_store);
    switch (action.runtimeType) {
      case StartOfflineGameAction:
        _startOfflineGame(action);
        break;
      case StartOnlineGameAction:
        _startOnlineGame(action);
        break;
      case EnterRoomAction:
        _enterRoom(action);
        break;
      case ExitRoomAction:
        _exitRoom();
        break;
      case ToggleSelectedCardAction:
        _toggleCard(action);
        break;
      case UncoverCardsAction:
        _uncoverCards();
        break;
      case ReplaceCardsAction:
        _replaceCards();
        break;
      case EndTurnAction:
        _endTurn();
        break;
      case BackToMenuAction:
        _backToMenu();
        break;
      default:
        throw "Unhandled action or store didn't change (Reducer shouldn't return the same store), action: ${action.toString()}";
    }
    _setGameState();
    return _store;
  }

  GameStore _loadRooms(GameStore store, LoadRoomsAction action) {
    store.onlineRooms.clear();
    store.onlineRooms.insertAll(0, action.rooms);
    return store;
  }

  static GameState getGameState(GameStore store) {
    if (store.localStore.isOnlineGame()) {
      return store.onlineRooms[store.localStore.currentOnlineRoom].gameState;
    } else {
      return store.offlineGameState;
    }
  }

  static int getCurrentPlayer(GameStore store) {
    return store.localStore.onlinePlayerIndex ??
        store.offlineGameState.currentPlayerIndex;
  }

  static Room getCurrentOnlineRoom(GameStore store) {
    return store.onlineRooms[store.localStore.currentOnlineRoom];
  }

  void _setGameState() {
    if (_state != null &&
        _store.localStore.currentOnlineRoom != null &&
        _store.onlineRooms.length > _store.localStore.currentOnlineRoom) {
      _store.onlineRooms[_store.localStore.currentOnlineRoom].gameState =
          _state;
    }
  }

  void _createOfflineGame() {
    _store.offlineGameState = GameState();
    _state = getGameState(_store);
    _state.gameStarted = true;
  }

  void _updateNumberOfPlayers(int newNumofPlayers) {
    _state.players = List<Player>.generate(
        newNumofPlayers, (int index) => Player(index),
        growable: false);
  }

  void _shuffleDeck() {
    _state.deck.cards.shuffle();
  }

  void _startOfflineGame(StartOfflineGameAction action) {
    _createOfflineGame();
    _updateNumberOfPlayers(action.numOfPlayers);
    _shuffleDeck();
    _handOutCardsToPlayers();
  }

  void _startOnlineGame(StartOnlineGameAction action) {
    _shuffleDeck();
    _handOutCardsToPlayers();
    _state.gameStarted = true;
  }

  void _enterRoom(EnterRoomAction action) {
    _store.localStore.currentOnlineRoom = action.roomId;
    _store.localStore.onlinePlayerIndex = _store
        .onlineRooms[_store.localStore.currentOnlineRoom]
        .gameState
        .players
        .length;
    _state = getGameState(_store);
    _state.numOfPlayers++;
    _state.players.add(Player(_store.localStore.onlinePlayerIndex));
    _store.localStore.waitingInRoom = true;
  }

  void _exitRoom() {
    _state.players.removeWhere((Player player) {
      return player.playerIndex == _store.localStore.onlinePlayerIndex;
    });
    _state.numOfPlayers--;
    _store.localStore.waitingInRoom = false;
  }

  void _handOutCardsToPlayers() {
    if (HandOutStrategy.allCardsAtOnce == _state.handOutStrategy) {
      _allCardsAtOnceHandOutStrategy();
    } else if (HandOutStrategy.oneByOneCard == _state.handOutStrategy) {
      _oneByOneCardHandOutStrategy();
    }
    _sortPlayersCards();
  }

  void _allCardsAtOnceHandOutStrategy() {
    for (int playerIndex = 0;
        playerIndex < _state.players.length;
        playerIndex++) {
      for (int cardNum = 0; cardNum < Hand.maxNumOfCards; cardNum++) {
        _handOutCardToPlayer(playerIndex);
      }
    }
  }

  void _oneByOneCardHandOutStrategy() {
    for (int cardNum = 0; cardNum < Hand.maxNumOfCards; cardNum++) {
      for (int playerIndex = 0;
          playerIndex < _state.players.length;
          playerIndex++) {
        _handOutCardToPlayer(playerIndex);
      }
    }
  }

  void _handOutCardToPlayer(int playerIndex) {
    _state.players[playerIndex].hand.cards.add(_state.deck.cards.removeLast());
  }

  void _sortPlayersCards() {
    for (int playerIndex = 0;
        playerIndex < _state.players.length;
        playerIndex++) {
      _sortPlayerCards(playerIndex);
    }
  }

  void _sortPlayerCards(int playerIndex) {
    _state.players[playerIndex].hand.cards
        .sort((PlayingCard lCard, PlayingCard rCard) => lCard.compareTo(rCard));
  }

  void _toggleCard(ToggleSelectedCardAction action) {
    _state.players[getCurrentPlayer(_store)].hand.cards
        .firstWhere((PlayingCard card) =>
            card.color == action.selectedCard.color &&
            card.rank == action.selectedCard.rank)
        .selectedForReplace = !action.selectedCard.selectedForReplace;
  }

  void _uncoverCards() {
    _state.coverCards = false;
  }

  void _replaceCards() {
    final int playerIndex = getCurrentPlayer(_store);
    final int numOfCardsToReplace = _state.players[playerIndex].hand.cards
        .where((PlayingCard card) => card.selectedForReplace)
        .length;
    _state.players[playerIndex].hand.cards
        .removeWhere((PlayingCard card) => card.selectedForReplace);
    for (int cardNum = 0; cardNum < numOfCardsToReplace; cardNum++) {
      _handOutCardToPlayer(playerIndex);
    }
    _sortPlayerCards(playerIndex);
    _state.players[playerIndex].replacedCards = true;
  }

  void _endTurn() {
    if (!_state.gameEnded) {
      if (_state.numOfPlayersEndTurns == _state.players.length - 1) {
        _endGame();
      } else {
        if (_store.localStore.isOnlineGame()) {
          _store.localStore.onlineTurnEnded = true;
        } else {
          _state.currentPlayerIndex += 1;
          _state.coverCards = true;
        }
        _state.numOfPlayersEndTurns++;
      }
    }
  }

  void _endGame() {
    _calculateHands();
    _state.gameEnded = true;
  }

  void _calculateHands() {
    for (Player player in _state.players) {
      player.handStrength =
          _handStrengthChecker.checkHandStrength(player.hand.cards);
    }
  }

  void _backToMenu() {
    _state = GameState();
  }
}
