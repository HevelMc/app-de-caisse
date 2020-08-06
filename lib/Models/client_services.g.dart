// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_services.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientService _$ClientServiceFromJson(Map<String, dynamic> json) {
  return ClientService(
    json['client'] == null
        ? null
        : Client.fromJson(json['client'] as Map<String, dynamic>),
    json['service'] == null
        ? null
        : Service.fromJson(json['service'] as Map<String, dynamic>),
    json['date'] == null ? null : DateTime.parse(json['date'] as String),
  );
}

Map<String, dynamic> _$ClientServiceToJson(ClientService instance) =>
    <String, dynamic>{
      'client': instance.client,
      'service': instance.service,
      'date': instance.date?.toIso8601String(),
    };
