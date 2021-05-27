import 'package:flutter/material.dart';
import 'auth.dart';
import 'rootPage.dart';


void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'TodoApp',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        // mengarahkan home ke RootPage dengan parameter auth: Auth()
        home: new RootPage(auth: new Auth()));
  }
}