import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Week extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Week'),
      ),
      backgroundColor: Colors.white,
      child: Center(
        child: Text("test"),
      ),
    );
  }
}
