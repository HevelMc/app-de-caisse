import '../main.dart';
import 'client.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'service.dart';

class DataManager {
  save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return json.decode(prefs.getString(key));
  }

  remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  saveList(String key, List<String> list) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, list);
  }

  Future<List<String>> getList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key);
  }

  String mapToJson(Map<String, dynamic> list) {
    return json.encode(list);
  }

  jsonToMap(String string) {
    return json.decode(string);
  }

  Future<List<Service>> loadServices() async {
    List<Service> list = List();

    List<String> jsonList = await DataManager().getList("services");
    if (jsonList == null) return List();
    jsonList.forEach((element) {
      list.add(Service.fromJson(DataManager().jsonToMap(element)));
    });

    return list;
  }

  Future<List<Client>> loadClients() async {
    List<Client> list = List();

    List<String> jsonList = await this.getList("clients");
    if (jsonList == null) return List();
    jsonList.forEach((element) {
      list.add(Client.fromJson(this.jsonToMap(element)));
    });

    return list;
  }

  saveServices() async {
    List<String> list = List();
    servicesList.forEach((element) {
      list.add(mapToJson(element.toJson()));
    });
    saveList("services", list);
  }

  saveClients() async {
    List<String> list = List();
    clientsList.forEach((element) {
      list.add(mapToJson(element.toJson()));
    });
    saveList("clients", list);
  }
}
