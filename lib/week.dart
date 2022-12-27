import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather/WeatherBackgroundColor.dart';
import 'package:weather/WeatherIcon.dart';
import 'package:weather/data.dart';

class Week extends StatefulWidget {
  const Week({super.key});

  @override
  State<Week> createState() => _WeekState();
}

class _WeekState extends State<Week> {
  List<WeatherData>? data = [];

  Future<void> getJson() async {
    final String response = await rootBundle.loadString('json/data.json');
    final data = await json.decode(response);
    setState(() {
      for (Map<String, dynamic> weather in data) {
        this.data?.add(WeatherData.fromJson(weather));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getJson();
  }

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

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Week'),
      ),
      backgroundColor: Colors.white,
      child: Center(
        child: Column(
          children: [
            for (int i = 0; i < data!.length; i++)
              Icon(
                convertWeathertImg(data![i].weather!.first.main.toString()),
              ),
          ],
        ),
      ),
    );
  }
}

Color getColor(String weather) {
  return WeatherBackgroundColor[weather]!;
}

String convertToCelsius(double kelvin) {
  return (kelvin - 273.15).toStringAsFixed(1) + "º";
}

IconData convertWeathertImg(String str) {
  return WeatherIcon[str]!;
}
