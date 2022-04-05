// ignore_for_file: public_member_api_docs

/*
Copyright 2022 by Mustafa Sezer <mustafa.sezer@hit-solutions.de>

This file is part of picos.

picos is free software: you can redistribute it and/or modify it under the
terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version.

picos is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
details.

You should have received a copy of the GNU General Public License along
with picos. If not, see <https://www.gnu.org/licenses/>.
*/

import 'package:flutter/material.dart';

void main() {
  runApp(const MainAppScreen());
}

class MainAppScreen extends StatefulWidget {
  const MainAppScreen({Key? key}) : super(key: key);

  @override
  State<MainAppScreen> createState() => MainAppScreenState();
}

class MainAppScreenState extends State<MainAppScreen> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PICOS',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'PICOS'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => MainAppClass();
}

class MainAppClass extends State<MyHomePage> {
  static const List<Widget> pages = <Widget>[
    Icon(
      Icons.house,
      size: 150,
    ),
    Icon(
      Icons.mail,
      size: 150,
    ),
    Icon(
      Icons.calendar_month,
      size: 150,
    ),
    Icon(
      Icons.bubble_chart,
      size: 150,
    )
  ];

  int selectedIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: appBarElements,
        ),
        centerTitle: false,
      ),
      body: Center(
        child: pages.elementAt(selectedIndex),
      ),
      backgroundColor: Colors.grey,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                Icons.house_outlined,
                color: Colors.black,
              ),
              label: 'Übersicht'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.mail_outline,
                color: Colors.black,
              ),
              label: 'Postfach'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.calendar_month_outlined,
                color: Colors.black,
              ),
              label: 'Kalender'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.chat_bubble_outline,
                color: Colors.black,
              ),
              label: 'MyPICOS'),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        onTap: onItemTapped,
      ),
    );
  }

  // ignore: always_specify_types
  List<Widget> get appBarElements => [
        Container(
          padding: const EdgeInsets.all(8.0),
          child: const Text(
            'DE | EN',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        )
      ];
}
