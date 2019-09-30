// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameStore _$GameStoreFromJson(Map<String, dynamic> json) {
  return GameStore()
    ..offlineGameState = json['gameState'] == null
        ? null
        : GameState.fromJson(json['gameState'] as Map<String, dynamic>)
    ..onlineRooms = (json['rooms'] as List)
        ?.map(
            (e) => e == null ? null : Room.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..currentOnlineRoom = json['currentRoom'] as int;
}

Map<String, dynamic> _$GameStoreToJson(GameStore instance) => <String, dynamic>{
      'gameState': instance.offlineGameState,
      'rooms': instance.onlineRooms,
      'currentRoom': instance.currentOnlineRoom,
    };
