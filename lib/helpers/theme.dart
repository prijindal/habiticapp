import 'package:flutter/material.dart';

ThemeData lightTheme = new ThemeData.light();

ThemeData mainTheme = new ThemeData(
  primarySwatch: Colors.deepPurple,
  accentColor: Colors.purple[400],
  textTheme: lightTheme.textTheme.merge(
    new TextTheme(
      body1: lightTheme.textTheme.body1.merge(
        new TextStyle(
          fontSize: 16.0
        )
      )
    )
  )
);
