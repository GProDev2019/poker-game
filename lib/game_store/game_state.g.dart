// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameState _$GameStateFromJson(Map<String, dynamic> json) {
  return GameState()
    ..deck = json['deck'] == null
        ? null
        : Deck.fromJson(json['deck'] as Map<String, dynamic>)
    ..players = (json['players'] as List)
        ?.map((e) =>
            e == null ? null : Player.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..currentPlayerIndex = json['currentPlayerIndex'] as int
    ..numOfPlayers = json['numOfPlayers'] as int
    ..numOfPlayersEndTurns = json['numOfPlayersEndTurns'] as int
    ..handOutStrategy =
        _$enumDecodeNullable(_$HandOutStrategyEnumMap, json['handOutStrategy'])
    ..gameEnded = json['gameEnded'] as bool
    ..gameStarted = json['gameStarted'] as bool;
}

Map<String, dynamic> _$GameStateToJson(GameState instance) => <String, dynamic>{
      'deck': instance.deck,
      'players': instance.players,
      'currentPlayerIndex': instance.currentPlayerIndex,
      'numOfPlayers': instance.numOfPlayers,
      'numOfPlayersEndTurns': instance.numOfPlayersEndTurns,
      'handOutStrategy': _$HandOutStrategyEnumMap[instance.handOutStrategy],
      'gameEnded': instance.gameEnded,
      'gameStarted': instance.gameStarted,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$HandOutStrategyEnumMap = {
  HandOutStrategy.oneByOneCard: 'oneByOneCard',
  HandOutStrategy.allCardsAtOnce: 'allCardsAtOnce',
};
