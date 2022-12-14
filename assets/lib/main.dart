import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
// Json data 받아오기
  Future<String> data = getJsonData();
  print("asdf " + data.toString());
  Map<String, dynamic> json = convertStringToJson(data.toString());
  print(json);

  runApp(const MyApp());
}

Future<String> getJsonData() async {
  final Future<String> response =
      rootBundle.loadString('json/WeatherData.json');
  return response;
}

Map<String, dynamic> convertStringToJson(String string) {
  Map<String, dynamic> json = jsonDecode(string);
  return json;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Text("dasd"),
    );
  }
}
