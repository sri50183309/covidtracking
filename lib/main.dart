import 'package:covidtracker/sidemenu/menu_layout/menu_dashboard_layout.dart';
import 'package:flutter/material.dart';
import 'coviddatapage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'COVID Tracking',
      theme: ThemeData.dark(),
      home: MenuDashboardLayout(),
    );
  }
}
