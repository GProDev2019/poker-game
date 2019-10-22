import 'package:poker_game/game_store/playing_card.dart';
import 'package:poker_game/middleware/room.dart';

class StartOfflineGameAction {
  final int numOfPlayers;
  StartOfflineGameAction(this.numOfPlayers);
}

class ToggleSelectedCardAction {
  final PlayingCard selectedCard;
  ToggleSelectedCardAction(this.selectedCard);
}

class UncoverCardsAction {}

class ReplaceCardsAction {}

class EndTurnAction {}

class BackToMenuAction {}

class StartOnlineGameAction {
  final int numOfPlayers;
  StartOnlineGameAction(this.numOfPlayers);
}

class DownloadRoomsAction {}

class EnterRoomAction {
  final int roomId;
  EnterRoomAction(this.roomId);
}

class ExitRoomAction {}

class CleanLocalStoreAction {}

class UpdateRoomAction {
  final Room room;
  UpdateRoomAction(this.room);
}

class LoadRoomsAction {
  final List<Room> rooms;
  LoadRoomsAction(this.rooms);
}

class CreateRoomAction {
  final Room room;
  CreateRoomAction(this.room);
}

class DeleteRooomAction {
  final String roomId;
  DeleteRooomAction(this.roomId);
}

class FacebookAuthAction {}

class SetPlayerNameAction {
  final String playerName;
  SetPlayerNameAction(this.playerName);
}
