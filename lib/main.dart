import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:weather/WeatherBackgroundColor.dart';
import 'package:weather/WeatherIcon.dart';
import 'package:weather/data.dart';
import 'package:weather/week.dart';

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

  Future<void> fetchWeatherData() async {
    var lat = 37.48752663774215;
    var lon = 126.82578055762251;
    var API_KEY = 'b719e4ef6551206d836fbb0812901195';
    String url =
        "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$API_KEY";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      print("응답");
      setState(() {
        this.data = WeatherData.fromJson(json.decode(response.body));
      });
      print(response.body);
    } else {
      throw Exception('API 호출 에러 발생');
    }
  }

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
    // getJson();
    fetchWeatherData();
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
        middle: Text("weather"),
        trailing: CupertinoButton(
          padding: EdgeInsets.all(0),
          child: Icon(
            CupertinoIcons.refresh,
          ),
          onPressed: () {
            setState(() {
              fetchWeatherData();
            });
          },
        ),
      ),
      backgroundColor: getColor(data!.weather!.first.main!),
      child: Column(
        children: [
          Padding(padding: EdgeInsets.all(90)),
          Center(
            child: WeatherContainer(data: data),
          ),
          Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Week(),
                    ),
                  );
                },
                child: Text("Week"),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class WeatherContainer extends StatelessWidget {
  final WeatherData? data;

  const WeatherContainer({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
        Icon(
          convertWeathertImg(data!.weather!.first.main.toString()),
          size: 65,
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
            Icon(
              CupertinoIcons.wind,
              size: 20,
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

Color getColor(String weather) {
  return WeatherBackgroundColor[weather]!;
}

String convertToCelsius(double kelvin) {
  return (kelvin - 273.15).toStringAsFixed(1) + "º";
}

IconData convertWeathertImg(String str) {
  return WeatherIcon[str]!;
}
