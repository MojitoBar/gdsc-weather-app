import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather/WeatherIcon.dart';
import 'package:weather/data.dart';

void main() {
// Json data 받아오기
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WeatherBody(),
    );
  }
}

class WeatherBody extends StatefulWidget {
  const WeatherBody({super.key});

  @override
  State<WeatherBody> createState() => _WeatherBodyState();
}

class _WeatherBodyState extends State<WeatherBody> {
  WeatherData? data = null;
  Future<void> getJson() async {
    final String response = await rootBundle.loadString('json/data.json');
    final data = await json.decode(response);
    setState(() {
      this.data = WeatherData.fromJson(data);
    });
  }

  @override
  void initState() {
    super.initState();
    getJson();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: LocationText(data: data),
      ),
    );
  }
}

class LocationText extends StatelessWidget {
  final WeatherData? data;

  const LocationText({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return Text(
        "Loading...",
        style: TextStyle(
          color: Colors.black,
          decoration: TextDecoration.none,
        ),
      );
    }
    return Column(
      children: [
        Padding(padding: EdgeInsets.all(30)),
        Text(
          "${data!.name.toString()}, ${data!.sys!.country}",
          style: TextStyle(
            color: Colors.black,
            fontSize: 19,
            decoration: TextDecoration.none,
          ),
        ),
        Padding(padding: EdgeInsets.all(3)),
        Text(
          data!.weather!.first.main.toString(),
          style: TextStyle(
            color: Color.fromARGB(255, 76, 76, 76),
            fontSize: 14,
            decoration: TextDecoration.none,
          ),
        ),
        Padding(padding: EdgeInsets.all(50)),
        Image(
          image: AssetImage(
            convertWeathertImg(data!.weather!.first.main.toString()),
          ),
          width: 80,
        ),
      ],
    );
  }
}

String convertWeathertImg(String str) {
  return WeatherIcon[str]!;
}
