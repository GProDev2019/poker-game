// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Room _$RoomFromJson(Map<String, dynamic> json) {
  return Room(
    json['title'] as String,
    json['gameState'] == null
        ? null
        : GameState.fromJson(json['gameState'] as Map<String, dynamic>),
  )..id = json['id'] as String;
}

Map<String, dynamic> _$RoomToJson(Room instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'gameState': instance.gameState,
    };
