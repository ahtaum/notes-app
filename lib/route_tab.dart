import 'package:flutter/material.dart';
import 'tabs/home/home.dart';
import 'tabs/notes/notes.dart';

class AppRouteTab {
  static const home = '/';
  static const notes = '/notes';

  static final tabPages = <Widget>[
    Home(),
    Notes(),
  ];

  static final tabs = <Tab>[
    Tab(text: 'Home'),
    Tab(text: 'Notes'),
  ];
}
