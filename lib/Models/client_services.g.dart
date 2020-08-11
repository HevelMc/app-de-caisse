// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_services.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientService _$ClientServiceFromJson(Map<String, dynamic> json) {
  return ClientService(
    json['service'] == null ? null : Service.fromJson(json['service'] as Map<String, dynamic>),
    json['date'] == null ? null : DateTime.parse(json['date'] as String),
    json['newPrice'] == null ? null : json['newPrice'] as double,
  );
}

Map<String, dynamic> _$ClientServiceToJson(ClientService instance) => <String, dynamic>{
      'service': instance.service?.toJson(),
      'date': instance.date?.toIso8601String(),
    };
