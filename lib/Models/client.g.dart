// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Client _$ClientFromJson(Map<String, dynamic> json) {
  return Client(
    json['firstName'] as String,
    json['lastName'] as String,
    json['email'] as String,
    json['number'] as int,
    json['postcode'] as int,
    json['birthDay'] as int,
    json['birthMonth'] as int,
  )
    ..id = json['id'] as int
    ..history = (json['history'] as List)
        ?.map((e) => e == null
            ? null
            : ClientService.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$ClientToJson(Client instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'number': instance.number,
      'postcode': instance.postcode,
      'birthDay': instance.birthDay,
      'birthMonth': instance.birthMonth,
      'history': instance.history?.map((e) => e?.toJson())?.toList(),
    };
