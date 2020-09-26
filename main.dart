import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'homepage.dart';
import 'model/course.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

