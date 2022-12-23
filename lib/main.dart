import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather/WeatherBackgroundColor.dart';
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
      backgroundColor: getColor(data!.weather!.first.main!),
      child: Center(
        child: LocationText(data: data),
      ),
    );
  }
}

Color getColor(String weather) {
  return WeatherBackgroundColor[weather]!;
}

class LocationText extends StatelessWidget {
  final WeatherData? data;

  const LocationText({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
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
          "Now",
          style: TextStyle(
            color: Color.fromARGB(255, 76, 76, 76),
            fontSize: 14,
            decoration: TextDecoration.none,
          ),
        ),
        Padding(padding: EdgeInsets.all(70)),
        Image(
          image: AssetImage(
            convertWeathertImg(data!.weather!.first.main.toString()),
          ),
          width: 50,
        ),
        Padding(padding: EdgeInsets.all(15)),
        Text(
          convertToCelsius(data!.main!.temp!),
          style: TextStyle(
            color: Color.fromARGB(255, 76, 76, 76),
            fontSize: 60,
            decoration: TextDecoration.none,
          ),
        ),
        Padding(padding: EdgeInsets.all(15)),
        Text(
          data!.weather!.first.main.toString(),
          style: TextStyle(
            color: Color.fromARGB(255, 76, 76, 76),
            fontSize: 16,
            decoration: TextDecoration.none,
          ),
        ),
        Padding(padding: EdgeInsets.all(25)),
        Text(
          "Wind",
          style: TextStyle(
            color: Color.fromARGB(255, 76, 76, 76),
            fontSize: 13,
            decoration: TextDecoration.none,
          ),
        ),
        Padding(padding: EdgeInsets.all(5)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage("images/wind.png"),
              width: 15,
            ),
            Padding(padding: EdgeInsets.all(3)),
            Text(
              data!.wind!.speed!.toStringAsFixed(0) + "m/s",
              style: TextStyle(
                color: Color.fromARGB(255, 76, 76, 76),
                fontSize: 13,
                decoration: TextDecoration.none,
              ),
            )
          ],
        ),
      ],
    );
  }
}

String convertToCelsius(double kelvin) {
  return (kelvin - 273.15).toStringAsFixed(1) + "º";
}

String convertWeathertImg(String str) {
  return WeatherIcon[str]!;
}
