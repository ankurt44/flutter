import 'package:flutter/material.dart';
import 'items_selection.dart';
import 'items.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          title: TextStyle(
            fontSize: 25.0,
            fontStyle: FontStyle.italic,
            color: Colors.black,
          ),
          subtitle: TextStyle(
            fontSize: 15.0,
            fontStyle: FontStyle.normal,
            color: Colors.black,
          ),
          display1: TextStyle(
            fontSize: 20.0,
            fontStyle: FontStyle.normal,
            color: Colors.black,
          ),
          button: TextStyle(
            fontSize: 20.0,
            fontStyle: FontStyle.normal,
            color: Colors.black,
          ),
        ),
        buttonTheme: ButtonThemeData(
          splashColor: Colors.grey,
        ),
      ),
      home: ItemsSelectionPage(Items.getItems()),
    );
  }
}