// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playing_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayingCard _$PlayingCardFromJson(Map<String, dynamic> json) {
  return PlayingCard(
    _$enumDecodeNullable(_$CardRankEnumMap, json['rank']),
    _$enumDecodeNullable(_$CardColorEnumMap, json['color']),
    json['selectedForReplace'] as bool,
  )..cardImagePath = json['cardImagePath'] as String;
}

Map<String, dynamic> _$PlayingCardToJson(PlayingCard instance) =>
    <String, dynamic>{
      'cardImagePath': instance.cardImagePath,
      'rank': _$CardRankEnumMap[instance.rank],
      'color': _$CardColorEnumMap[instance.color],
      'selectedForReplace': instance.selectedForReplace,
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

const _$CardColorEnumMap = {
  CardColor.hearts: 'hearts',
  CardColor.diamonds: 'diamonds',
  CardColor.clubs: 'clubs',
  CardColor.spades: 'spades',
};
