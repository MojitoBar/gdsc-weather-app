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
  List<String> date = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (int i = 0; i < data!.length; i++)
              Container(
                width: 60,
                height: 180,
                decoration: BoxDecoration(
                  color: getColor(data![i].weather!.first.main.toString()),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              date[i],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            Icon(
                              convertWeathertImg(
                                  data![i].weather!.first.main.toString()),
                              size: 40,
                            ),
                            Text(
                              convertToCelsius(data![i].main!.temp!.toDouble()),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(12)),
                            Text(
                              "Wind",
                              style: TextStyle(
                                color: Color.fromARGB(255, 76, 76, 76),
                                fontSize: 12,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  CupertinoIcons.wind,
                                  size: 15,
                                ),
                                Padding(padding: EdgeInsets.all(3)),
                                Text(
                                  data![i].wind!.speed!.toStringAsFixed(0) +
                                      "m/s",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 76, 76, 76),
                                    fontSize: 11,
                                    decoration: TextDecoration.none,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.all(10)),
                  ],
                ),
              )
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
