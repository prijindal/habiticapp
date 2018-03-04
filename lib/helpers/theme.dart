import 'package:flutter/material.dart';

ThemeData lightTheme = new ThemeData.light();
TextTheme primaryTextTheme = new Typography(
  platform: TargetPlatform.android
).white;

ThemeData mainTheme = new ThemeData(
  primarySwatch: Colors.deepPurple,
  accentColor: Colors.purple[400],
  primaryTextTheme: primaryTextTheme.merge(new TextTheme(
    subhead: primaryTextTheme.subhead.merge(
     new TextStyle(
       color: new Color(0xFFFFFFFF),
       fontSize: 14.0,
       fontFamily: "Roboto Medium"
      ), 
    ),
    caption: primaryTextTheme.caption.merge(
     new TextStyle(
       color: new Color(0xFFFFFFFF),
       fontSize: 14.0,
       fontFamily: "Roboto Regular"
      ), 
    ),
  )),
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
