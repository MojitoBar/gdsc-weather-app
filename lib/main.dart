import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  Map<String, dynamic> data = {};
  Future<void> getJson() async {
    final String response = await rootBundle.loadString('json/data.json');
    final data = await json.decode(response);
    setState(() {
      this.data = data;
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
      navigationBar: CupertinoNavigationBar(
        middle: Text("Weather App"),
      ),
      child: Center(
        child: TestWidget(data: data),
      ),
    );
  }
}

class TestWidget extends StatelessWidget {
  Map<String, dynamic> data;
  TestWidget({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    if (data.length == 0) {
      return Text(
        "Loading...",
        style: TextStyle(
          color: Colors.black,
          decoration: TextDecoration.none,
        ),
      );
    }
    return Text(
      data['name'],
      style: TextStyle(
        color: Colors.black,
        decoration: TextDecoration.none,
      ),
    );
  }
}
