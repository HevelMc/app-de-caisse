import 'package:json_annotation/json_annotation.dart';

import 'service.dart';

part 'service_category.g.dart';

@JsonSerializable(nullable: true, explicitToJson: true)
class ServiceCategory {
  String name;
  List<Service> list = [];
  int id;

  ServiceCategory(this.name);

  factory ServiceCategory.fromJson(Map<String, dynamic> json) =>
      _$ServiceCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceCategoryToJson(this);
}
