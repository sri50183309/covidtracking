import 'package:covidtracker/model/ByCountry.dart';
import 'package:covidtracker/model/ByIndia.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:provider/provider.dart';

import 'bloc/navigation_bloc/navigation_bloc.dart';
import 'model/Constants.dart';

class COVIDDataPage extends StatefulWidget with NavigationStates {
  final Widget child;
  COVIDDataPage({Key key, this.child}) : super(key: key);
  _COVIDDataPageState createState() => _COVIDDataPageState();
}

class _COVIDDataPageState extends State<COVIDDataPage> {
  Future<List> getWorldStatistics() async {
    http.Response response = await http.get(Constants.COVID_STATS_IN_WORLD);
    return COVIDByCountry.byTotalCases(json.decode(response.body));
  }

  Future<List> getIndiaStatistics() async {
    http.Response response = await http.get(Constants.COVID_sTATS_IN_INDIA);
    return COVIDInIndia.byTotalCases(json.decode(response.body));
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

class DisplayData extends StatelessWidget {
  final List covidInWholeWolrd;
  final List covidInIndia;
  List<charts.Series<COVIDByCountry, String>> _covidByCountry =
      List<charts.Series<COVIDByCountry, String>>();

  DisplayData(this.covidInWholeWolrd, this.covidInIndia);

  DataRow _getDataRow(COVIDInIndia result) {
    return DataRow(
      cells: <DataCell>[
        DataCell(Text(
          result.state,
          style: TextStyle(
              fontStyle: FontStyle.normal, color: Colors.black, fontSize: 15),
        )),
        DataCell(Text(
          "${result.confirmed}",
          style: TextStyle(
              fontStyle: FontStyle.normal, color: Colors.red, fontSize: 20),
        )),
        DataCell(Text(
          "${result.deaths}",
          style: TextStyle(
              fontStyle: FontStyle.normal,
              color: Colors.redAccent,
              fontSize: 20),
        )),
      ],
    );
  }

  _generateData() {
    var covidByTotalCases = this.covidInWholeWolrd;
    _covidByCountry.add(
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
              createChartsInFirstTab(),
              createListViewBuilderIn2ndTab(),
              createDataTableIn3rdTab(),
            ],
          ),
        ),
      ),
    );
  }

  /**
   * This creates a dynamic datatable in 3rd tab
   */
  Padding createDataTableIn3rdTab() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columnSpacing: 2,
          dividerThickness: 5,
          columns: [
            DataColumn(
              label: Text('State',
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.black)),
            ),
            DataColumn(
              label: Text('Confirmed',
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.black)),
            ),
            DataColumn(
              label: Text('Death',
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.black)),
            ),
          ],
          rows: List.generate(
              covidInIndia.length, (index) => _getDataRow(covidInIndia[index])),
        ),
      ),
    );
  }

  /**
   * This create dynamic list view builder in 2nd tab
   */
  Padding createListViewBuilderIn2ndTab() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: covidInWholeWolrd == null ? 0 : covidInWholeWolrd.length,
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
    );
  }

  /**
   * This method create bar chart using flutter sdk
   * This will be displayed in First Tab
   */
  Padding createChartsInFirstTab() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'No of cases, by world region',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
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
    );
  }
}
