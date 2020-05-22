import 'package:covidtracker/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:covidtracker/model/Constants.dart';
import 'package:flutter/material.dart';
import 'package:covidtracker/model/ByCountry.dart';
import 'package:covidtracker/model/ByIndia.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../coviddatapage.dart';

class MyAccountsPage extends StatelessWidget with NavigationStates {
  Future<List> getWorldStatistics() async {
    http.Response response = await http.get(Constants.COVID_STATS_IN_WORLD);
    return COVIDByCountry.byTotalCases(json.decode(response.body));
  }

  Future<List> getIndiaStatistics() async {
    http.Response response = await http.get(Constants.COVID_sTATS_IN_INDIA);
    return COVIDInIndia.byTotalCases(json.decode(response.body));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: Future.wait([getWorldStatistics(), getIndiaStatistics()]),
          builder: (context, AsyncSnapshot<List> snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator(
                backgroundColor: Colors.cyanAccent,
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
              );
            } else {
              return DisplayData(snapshot.data[0], snapshot.data[1]);
            }
          },
        ),
      ),
      bottomNavigationBar:
          BottomNavigationBar(type: BottomNavigationBarType.fixed, items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.share,
            color: Colors.purple,
          ),
          title: Text(
            "Share",
            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.purple),
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.rate_review, color: Colors.purple),
          title: Text("Rate App",
              style:
                  TextStyle(fontStyle: FontStyle.italic, color: Colors.purple)),
        )
      ]),
    );
  }
}
