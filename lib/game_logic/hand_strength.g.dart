// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hand_strength.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HandStrength _$HandStrengthFromJson(Map<String, dynamic> json) {
  return HandStrength(
    _$enumDecodeNullable(_$HandNameEnumMap, json['handName']),
    (json['cardRanks'] as List)
        ?.map((e) => _$enumDecodeNullable(_$CardRankEnumMap, e))
        ?.toList(),
    _$enumDecodeNullable(_$CardRankEnumMap, json['higherCardRank']),
    _$enumDecodeNullable(_$CardRankEnumMap, json['lowerCardRank']),
  );
}

Map<String, dynamic> _$HandStrengthToJson(HandStrength instance) =>
    <String, dynamic>{
      'handName': _$HandNameEnumMap[instance.handName],
      'higherCardRank': _$CardRankEnumMap[instance.higherCardRank],
      'lowerCardRank': _$CardRankEnumMap[instance.lowerCardRank],
      'cardRanks':
          instance.cardRanks?.map((e) => _$CardRankEnumMap[e])?.toList(),
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

const _$HandNameEnumMap = {
  HandName.highCard: 'highCard',
  HandName.pair: 'pair',
  HandName.twoPairs: 'twoPairs',
  HandName.threeOfAKind: 'threeOfAKind',
  HandName.straight: 'straight',
  HandName.flush: 'flush',
  HandName.fullHouse: 'fullHouse',
  HandName.fourOfAKind: 'fourOfAKind',
  HandName.poker: 'poker',
};

const _$CardRankEnumMap = {
  CardRank.two: 'two',
  CardRank.three: 'three',
  CardRank.four: 'four',
  CardRank.five: 'five',
  CardRank.six: 'six',
  CardRank.seven: 'seven',
  CardRank.eight: 'eight',
  CardRank.nine: 'nine',
  CardRank.ten: 'ten',
  CardRank.jack: 'jack',
  CardRank.queen: 'queen',
  CardRank.king: 'king',
  CardRank.ace: 'ace',
};
