import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:poker_game/game_store/game_state.dart';
import 'package:poker_game/game_store/game_store.dart';
import 'package:poker_game/game_store/playing_card.dart';
import 'package:poker_game/game_store/hand.dart';
import 'package:poker_game/game_store/player.dart';
import 'package:poker_game/middleware/room.dart';
import 'actions.dart';
import 'hand_names.dart';

class Dispatcher {
  final HandStrengthChecker _handStrengthChecker = HandStrengthChecker();
  GameStore _store;
  GameState _state;

  GameStore dispatchPokerGameAction(GameStore store, dynamic action) {
    _store = store;
    _state = getGameState(_store);
    switch (action.runtimeType) {
      case NavigateToAction:
        break;
      case StartOfflineGameAction:
        _startOfflineGame(action);
        break;
      case StartOnlineGameAction:
        _startOnlineGame(action);
        break;
      case LoadRoomsAction:
        _loadRooms(action);
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

  static GameState getGameState(GameStore store) {
    if (store.rooms.isEmpty) {
      return null;
    }
    return store.rooms[store.currentRoom].gameState;
  }

  void _setGameState() {
    _store.rooms[_store.currentRoom].gameState = _state;
  }

  void _createLocalRoom(String roomTitle) {
    _store.rooms.insert(Room.offlineGameRoomId, Room(roomTitle, GameState()));
    _store.currentRoom = Room.offlineGameRoomId;
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
    _updateNumberOfPlayers(action.numOfPlayers);
    _shuffleDeck();
    _handOutCardsToPlayers();
  }

  void _loadRooms(LoadRoomsAction action) {
    _store.rooms = action.rooms;
  }

  void _enterRoom(EnterRoomAction action) {
    _store.currentRoom = action.roomId;
    _state.currentPlayer = _state.players.length;
    _state.players.add(Player(_state.currentPlayer));
  }

  void _exitRoom() {
    _state.players.removeWhere((Player player) {
      return player.playerIndex == _state.currentPlayer;
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
    _state.players[_state.currentPlayer].hand.cards
        .firstWhere((PlayingCard card) =>
            card.color == action.selectedCard.color &&
            card.rank == action.selectedCard.rank)
        .selectedForReplace = !action.selectedCard.selectedForReplace;
  }

  void _replaceCards() {
    final int numOfCardsToReplace = _state
        .players[_state.currentPlayer].hand.cards
        .where((PlayingCard card) => card.selectedForReplace)
        .length;
    _state.players[_state.currentPlayer].hand.cards
        .removeWhere((PlayingCard card) => card.selectedForReplace);
    for (int cardNum = 0; cardNum < numOfCardsToReplace; cardNum++) {
      _handOutCardToPlayer(_state.currentPlayer);
    }
    _sortPlayerCards(_state.currentPlayer);
    _state.players[_state.currentPlayer].replacedCards = true;
  }

  void _endTurn() {
    if (_state.currentPlayer == _state.players.length - 1) {
      _endGame();
    } else {
      _state.currentPlayer += 1;
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
    _store = GameStore.initial();
  }
}
