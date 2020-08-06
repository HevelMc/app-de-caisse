import 'package:json_annotation/json_annotation.dart';

import 'client.dart';
import 'service.dart';

part 'client_services.g.dart';

@JsonSerializable(nullable: true, explicitToJson: true)
class ClientService {
  Service service;
  DateTime date;
  ClientService(Service service, DateTime date) {
    this.service = service;
    this.date = date;
  }

  factory ClientService.fromJson(Map<String, dynamic> json) =>
      _$ClientServiceFromJson(json);
  Map<String, dynamic> toJson() => _$ClientServiceToJson(this);
}
