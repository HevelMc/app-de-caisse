import 'package:json_annotation/json_annotation.dart';

import 'service.dart';

part 'client_services.g.dart';

@JsonSerializable(nullable: true, explicitToJson: true)
class ClientService {
  Service service;
  DateTime date;
  double newPrice;
  ClientService(Service service, DateTime date, double newPrice) {
    this.service = service;
    this.date = date;
    this.newPrice = newPrice;
  }

  factory ClientService.fromJson(Map<String, dynamic> json) => _$ClientServiceFromJson(json);
  Map<String, dynamic> toJson() => _$ClientServiceToJson(this);
}
