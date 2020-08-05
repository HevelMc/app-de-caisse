import 'package:json_annotation/json_annotation.dart';

part 'service.g.dart';

@JsonSerializable(nullable: true)
class Service {
  String name;
  int price;
  int duration;
  bool package;
  int id;

  Service(String name, int price, int duration, bool package) {
    this.name = name;
    this.price = price;
    this.duration = duration;
    this.package = package;
  }

  factory Service.fromJson(Map<String, dynamic> json) =>
      _$ServiceFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceToJson(this);

  String getName() {
    return this.name;
  }

  int getPrice() {
    return this.price;
  }

  String getDurationText() {
    int hours = duration ~/ 60;
    int minutes = duration % 60;

    if (hours > 0) {
      if (minutes == 0) return hours.toString() + "h";
      return hours.toString() + "h " + minutes.toString() + "m";
    }
    return minutes.toString() + "m";
  }
}
