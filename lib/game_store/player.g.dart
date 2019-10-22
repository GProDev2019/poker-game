// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Player _$PlayerFromJson(Map<String, dynamic> json) {
  return Player(
    json['playerIndex'] as int,
    json['playerName'] as String,
  )
    ..hand = json['hand'] == null
        ? null
        : Hand.fromJson(json['hand'] as Map<String, dynamic>)
    ..handStrength = json['handStrength'] == null
        ? null
        : HandStrength.fromJson(json['handStrength'] as Map<String, dynamic>)
    ..replacedCards = json['replacedCards'] as bool;
}

Map<String, dynamic> _$PlayerToJson(Player instance) => <String, dynamic>{
      'hand': instance.hand,
      'handStrength': instance.handStrength,
      'playerIndex': instance.playerIndex,
      'replacedCards': instance.replacedCards,
      'playerName': instance.playerName,
    };
