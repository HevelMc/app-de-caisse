// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Service _$ServiceFromJson(Map<String, dynamic> json) {
  return Service(
    json['name'] as String,
    double.parse(json['price'].toString()),
    json['duration'] as int,
    json['package'] as bool,
  )..id = json['id'] as int;
}

Map<String, dynamic> _$ServiceToJson(Service instance) => <String, dynamic>{
      'name': instance.name,
      'price': instance.price,
      'duration': instance.duration,
      'package': instance.package,
      'id': instance.id,
    };
