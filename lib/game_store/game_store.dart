import 'package:json_annotation/json_annotation.dart';
import 'package:poker_game/middleware/room.dart';

import 'game_state.dart';

part 'game_store.g.dart';

@JsonSerializable()
class GameStore {
  GameState gameState = GameState();
  List<Room> rooms = <Room>[Room()];
  int currentRoom;

  GameStore();

  factory GameStore.initial() => GameStore();

  factory GameStore.fromJson(Map<String, dynamic> json) =>
      _$GameStoreFromJson(json);

  Map<String, dynamic> toJson() => _$GameStoreToJson(this);
}