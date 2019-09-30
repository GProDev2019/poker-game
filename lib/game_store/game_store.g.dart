// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameStore _$GameStoreFromJson(Map<String, dynamic> json) {
  return GameStore()
    ..gameState = json['gameState'] == null
        ? null
        : GameState.fromJson(json['gameState'] as Map<String, dynamic>)
    ..rooms = (json['rooms'] as List)
        ?.map(
            (e) => e == null ? null : Room.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..currentRoom = json['currentRoom'] as int;
}

Map<String, dynamic> _$GameStoreToJson(GameStore instance) => <String, dynamic>{
      'gameState': instance.gameState,
      'rooms': instance.rooms,
      'currentRoom': instance.currentRoom,
    };
