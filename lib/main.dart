import 'package:flutter/material.dart';
import 'package:movie_app/pages/main_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.amber,
          accentColor: Colors.amberAccent
      ),
      home: MyHomePage (),
    );
  }
}

