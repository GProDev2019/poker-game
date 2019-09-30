import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:poker_game/game_logic/hand_strength.dart';
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
  Map<Type, void Function([dynamic action])> actionMap;

  Dispatcher() {
    actionMap[StartOfflineGameAction] = _startOfflineGame;
  }

  GameStore dispatchPokerGameAction(GameStore store, dynamic action) {
    switch (action.runtimeType) {
      case LoadRoomsAction:
        _loadRooms(action);
        return _store;
      case ClearRoomsAction:
        _clearRooms();
        break;
      case NavigateToAction:
        return _store;
    }
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

  void _loadRooms(LoadRoomsAction action) {
    _clearRooms();
    _store.onlineRooms.insertAll(1, action.rooms);
  }

  static GameState getGameState(GameStore store) {
    if (store.onlineRooms.isEmpty ||
        store.currentOnlineRoom == null ||
        store.onlineRooms.length <= store.currentOnlineRoom) {
      return null;
    }
    return store.onlineRooms[store.currentOnlineRoom].gameState;
  }

  void _setGameState() {
    if (_state != null &&
        _store.currentOnlineRoom != null &&
        _store.onlineRooms.length > _store.currentOnlineRoom) {
      _store.onlineRooms[_store.currentOnlineRoom].gameState = _state;
    }
  }

  int _getCurrentPlayer() {
    // ToDo: Refactor this
    if (onlinePlayerIndex == -1) {
      return _state.currentPlayer;
    } else {
      return onlinePlayerIndex;
    }
  }

  void _createLocalRoom(String roomTitle) {
    _store.onlineRooms
        .insert(Room.offlineGameRoomId, Room(roomTitle, GameState()));
    _store.currentOnlineRoom = Room.offlineGameRoomId;
    _state = getGameState(_store);
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
    _createLocalRoom('Local');
    _updateNumberOfPlayers(action.numOfPlayers);
    _shuffleDeck();
    _handOutCardsToPlayers();
  }

  void _startOnlineGame(StartOnlineGameAction action) {
    //_updateNumberOfPlayers(action.numOfPlayers);
    _shuffleDeck();
    _handOutCardsToPlayers();
  }

  void _clearRooms() {
    _store.onlineRooms.removeRange(1, _store.onlineRooms.length);
  }

  void _enterRoom(EnterRoomAction action) {
    _store.currentOnlineRoom = action.roomId;
    _state = getGameState(_store);
    _state.numOfPlayers++;
    onlinePlayerIndex = _state.players.length; // ToDo: Do it prettier
    _state.players.add(Player(onlinePlayerIndex));
  }

  void _exitRoom() {
    _state.players.removeWhere((Player player) {
      _state.numOfPlayers--;
      return player.playerIndex == onlinePlayerIndex;
    });
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
    _state.players[_getCurrentPlayer()].hand.cards
        .firstWhere((PlayingCard card) =>
            card.color == action.selectedCard.color &&
            card.rank == action.selectedCard.rank)
        .selectedForReplace = !action.selectedCard.selectedForReplace;
  }

  void _replaceCards() {
    final int numOfCardsToReplace = _state
        .players[_getCurrentPlayer()].hand.cards
        .where((PlayingCard card) => card.selectedForReplace)
        .length;
    _state.players[_getCurrentPlayer()].hand.cards
        .removeWhere((PlayingCard card) => card.selectedForReplace);
    for (int cardNum = 0; cardNum < numOfCardsToReplace; cardNum++) {
      _handOutCardToPlayer(_getCurrentPlayer());
    }
    _sortPlayerCards(_getCurrentPlayer());
    _state.players[_getCurrentPlayer()].replacedCards = true;
  }

  void _endTurn() {
    if (!_state.gameEnded) {
      if (_state.numOfPlayersEndTurns == _state.players.length - 1) {
        _endGame();
      } else {
        if (_store.currentOnlineRoom == 0) {
          // ToDo: Maybe do it prettier (maybe some additional flag to indicate offline game)
          _state.currentPlayer += 1; // offline game
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
