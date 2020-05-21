import 'package:covidtracker/model/ByCountry.dart';
import 'package:covidtracker/model/ByIndia.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final Widget child;

  HomePage({Key key, this.child}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List> getWorldStatistics() async {
    http.Response response = await http.get(
        "https://corona-virus-stats.herokuapp.com/api/v1/cases/countries-search?limit=20&page=1");

    return COVIDByCountry.byTotalCases(json.decode(response.body));
  }

  Future<List> getIndiaStatistics() async {
    http.Response response =
        await http.get("https://covid-19india-api.herokuapp.com/state_data");

    return COVIDInIndia.byTotalCases(json.decode(response.body));
  }

  Stream<List> getByCountry(Duration refreshTime) async* {
    await Future.delayed(refreshTime);
    yield await getWorldStatistics();
  }

  Stream<List> getInIndia(Duration refreshTime) async* {
    await Future.delayed(refreshTime);
    yield await getIndiaStatistics();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
            return LikeCounter(snapshot.data[0], snapshot.data[1]);
          }
        },
      )),
    );
  }
}

class LikeCounter extends StatelessWidget {
  final List covidInWholeWolrd;
  final List covidInIndia;
  List<charts.Series<COVIDByCountry, String>> _covidByCountry =
      List<charts.Series<COVIDByCountry, String>>();

  LikeCounter(this.covidInWholeWolrd, this.covidInIndia);

  DataRow _getDataRow(COVIDInIndia result) {
    return DataRow(
      cells: <DataCell>[
        DataCell(Text(result.state)),
        DataCell(Text("${result.confirmed}")),
        DataCell(Text("${result.deaths}")),
      ],
    );
  }

  _generateData() {
    var covidByTotalCases = this.covidInWholeWolrd;
    _covidByCountry.add(
      charts.Series(
        domainFn: (COVIDByCountry pollution, _) =>
            pollution.country_abbreviation,
        measureFn: (COVIDByCountry pollution, _) => pollution.total_cases,
        id: '1',
        data: covidByTotalCases,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (COVIDByCountry pollution, _) =>
            charts.ColorUtil.fromDartColor(pollution.colorval),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _generateData();
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            leading: Icon(
              FontAwesomeIcons.bars,
              color: Colors.yellow,
            ),
            backgroundColor: Color(0xff1976d2),
            //backgroundColor: Color(0xff308e1c),
            bottom: TabBar(
              indicatorColor: Color(0xff9962D0),
              tabs: [
                Tab(
                  icon: Icon(FontAwesomeIcons.solidChartBar),
                ),
                Tab(icon: Icon(FontAwesomeIcons.globe)),
                Tab(icon: Icon(FontAwesomeIcons.globeAsia)),
              ],
            ),
            title: Text('Covid Tracking in world'),
          ),
          body: TabBarView(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'No of cases, by world region',
                          style: TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
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
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount:
                      covidInWholeWolrd == null ? 0 : covidInWholeWolrd.length,
                  itemBuilder: (BuildContext context, int index) {
                    COVIDByCountry covidByCountr = covidInWholeWolrd[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundImage: NetworkImage(covidByCountr.flag),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                "${covidByCountr.country} \n Total Case: ${covidByCountr.totalCasesString} \n "
                                " Total Death: ${covidByCountr.total_deaths}",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columnSpacing: 2,
                    sortColumnIndex: 0,
                    dividerThickness: 5,
                    columns: [
                      DataColumn(label: Text('State')),
                      DataColumn(label: Text('Confirmed')),
                      DataColumn(label: Text('Death')),
                    ],
                    rows: List.generate(covidInIndia.length,
                        (index) => _getDataRow(covidInIndia[index])),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
