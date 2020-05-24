import 'package:covidtracker/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:covidtracker/model/ByCountry.dart';
import 'package:covidtracker/model/Constants.dart';
import 'package:flutter/material.dart';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class MyCardsPage extends StatelessWidget with NavigationStates {
  final Function onMenuTap;

  const MyCardsPage({Key key, this.onMenuTap}) : super(key: key);

  Future<List> getWorldStatistics() async {
    http.Response response = await http.get(Constants.COVID_STATS_IN_WORLD);
    return COVIDByCountry.byTotalCases(json.decode(response.body));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(40)),
        color: Colors.grey,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: ClampingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  InkWell(
                    child: Icon(Icons.menu, color: Colors.white),
                    onTap: onMenuTap,
                  ),
                  Text("COVID around the world",
                      style: TextStyle(fontSize: 24, color: Colors.white)),
                  Icon(Icons.settings, color: Colors.white),
                ],
              ),
              SizedBox(height: 50),
              Container(
                height: 300,
                child: PageView(
                  controller: PageController(viewportFraction: 0.8),
                  scrollDirection: Axis.horizontal,
                  pageSnapping: true,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      color: Colors.white70,
                      width: 100,
                      child: FutureBuilder(
                        future: Future.wait([getWorldStatistics()]),
                        builder: (context, AsyncSnapshot<List> snapshot) {
                          if (!snapshot.hasData) {
                            return CircularProgressIndicator(
                              backgroundColor: Colors.cyanAccent,
                              valueColor:
                                  new AlwaysStoppedAnimation<Color>(Colors.red),
                            );
                          } else {
                            List<COVIDByCountry> covidInWorld =
                                snapshot.data[0];
                            List<charts.Series<COVIDByCountry, String>>
                                _covidByCountry =
                                generateGraphData(covidInWorld);

                            return renderGraphInUI(_covidByCountry);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Data in Numbers",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              ListView.separated(
                shrinkWrap: true,
                itemBuilder: (covi, index) {
                  return ListTile(
                    title: Text("Macbook"),
                    subtitle: Text("Apple"),
                    trailing: Text("-2900"),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(height: 16);
                },
                itemCount: 10,
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Column renderGraphInUI(
      List<charts.Series<COVIDByCountry, String>> _covidByCountry) {
    return Column(
      children: <Widget>[
        Expanded(
          child: charts.BarChart(
            _covidByCountry,
            animate: true,
            barGroupingType: charts.BarGroupingType.grouped,
            //behaviors: [new charts.SeriesLegend()],
            animationDuration: Duration(seconds: 5),
          ),
        ),
      ],
    );
  }

  List<charts.Series<COVIDByCountry, String>> generateGraphData(
      List<COVIDByCountry> covidInWholeWolrd) {
    var covidByTotalCases = covidInWholeWolrd;
    return [
      charts.Series(
        domainFn: (COVIDByCountry covidInWorld, _) =>
            covidInWorld.country_abbreviation,
        measureFn: (COVIDByCountry covidInWorld, _) => covidInWorld.total_cases,
        id: '1',
        data: covidByTotalCases,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (COVIDByCountry covidInWorld, _) =>
            charts.ColorUtil.fromDartColor(covidInWorld.colorval),
      ),
    ];
  }
}
