// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deck.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Deck _$DeckFromJson(Map<String, dynamic> json) {
  return Deck(
    (json['cards'] as List)
        ?.map((e) =>
            e == null ? null : PlayingCard.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$DeckToJson(Deck instance) => <String, dynamic>{
      'cards': instance.cards,
    };
