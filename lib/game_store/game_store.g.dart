// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameStore _$GameStoreFromJson(Map<String, dynamic> json) {
  return GameStore()
    ..offlineGameState = json['offlineGameState'] == null
        ? null
        : GameState.fromJson(json['offlineGameState'] as Map<String, dynamic>)
    ..onlineRooms = (json['onlineRooms'] as List)
        ?.map(
            (e) => e == null ? null : Room.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..currentOnlineRoom = json['currentOnlineRoom'] as int;
}

Map<String, dynamic> _$GameStoreToJson(GameStore instance) => <String, dynamic>{
      'offlineGameState': instance.offlineGameState,
      'onlineRooms': instance.onlineRooms,
      'currentOnlineRoom': instance.currentOnlineRoom,
    };
