import 'package:json_annotation/json_annotation.dart';
import 'package:poker_game/game_store/game_state.dart';

part 'room.g.dart';

@JsonSerializable()
class Room {
  String id;
  String title;
  GameState gameState;
  Room(this.title, this.gameState);

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);

  Map<String, dynamic> toJson() => _$RoomToJson(this);
}
