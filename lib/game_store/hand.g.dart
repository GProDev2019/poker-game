// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hand.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Hand _$HandFromJson(Map<String, dynamic> json) {
  return Hand()
    ..cards = (json['cards'] as List)
        ?.map((e) =>
            e == null ? null : PlayingCard.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$HandToJson(Hand instance) => <String, dynamic>{
      'cards': instance.cards,
    };
