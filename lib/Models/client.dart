import 'package:Caisse/Models/client_services.dart';
import 'package:json_annotation/json_annotation.dart';

part 'client.g.dart';

@JsonSerializable(nullable: true)
class Client {
  int id;
  String firstName;
  String lastName;
  String email;
  int number;
  int postcode;
  int birthDay;
  int birthMonth;
  List<ClientService> history;

  Client(String firstName, String lastName, String email, int number,
      int postcode, int birthDay, int birthMonth) {
    this.firstName = capitalize(firstName);
    this.lastName = lastName.toUpperCase();
    this.email = email;
    this.number = number;
    this.postcode = postcode;
    this.birthDay = birthDay;
    this.birthMonth = birthMonth;
    this.history = List<ClientService>();
  }

  factory Client.fromJson(Map<String, dynamic> json) => _$ClientFromJson(json);
  Map<String, dynamic> toJson() => _$ClientToJson(this);

  String getName() {
    return this.firstName + " " + this.lastName;
  }

  String getNameReversed() {
    return this.lastName + " " + this.firstName;
  }
}

String capitalize(String string) {
  if (string == null) throw ArgumentError("string: $string");
  if (string.isEmpty) return string;
  List<String> split = string.split("");
  List<String> newSplit = List<String>();
  String previous = " ";
  split.forEach((element) {
    if (previous == " ")
      newSplit.add(element.toUpperCase());
    else
      newSplit.add(element);
    previous = element;
  });
  return newSplit.join();
}
