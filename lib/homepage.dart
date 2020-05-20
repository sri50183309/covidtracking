import 'package:covidtracker/model/ByCountry.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

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

  Stream<List> getByCountry(Duration refreshTime) async* {
    await Future.delayed(refreshTime);
    yield await getWorldStatistics();
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
          child: StreamBuilder(
        stream: getByCountry(Duration(seconds: 1)),
        initialData: null,
        builder: (context, stream) {
          if (stream.connectionState == ConnectionState.done) {
            return LikeCounter(stream.data);
          }
          if (stream.hasData) {
            return LikeCounter(stream.data);
          } else {
            return CircularProgressIndicator();
          }
        },
      )),
    );
  }
}

class LikeCounter extends StatelessWidget {
  final List num;

  List<charts.Series<Sales, int>> _seriesLineData =
      List<charts.Series<Sales, int>>();
  List<charts.Series<COVIDByCountry, String>> _covidByCountry =
      List<charts.Series<COVIDByCountry, String>>();

  LikeCounter(this.num);

  _generateData() {
    var covidByTotalCases = this.num;
    var linesalesdata = [
      new Sales(0, 45),
      new Sales(1, 56),
      new Sales(2, 55),
      new Sales(3, 60),
      new Sales(4, 61),
      new Sales(5, 70),
    ];
    var linesalesdata1 = [
      new Sales(0, 35),
      new Sales(1, 46),
      new Sales(2, 45),
      new Sales(3, 50),
      new Sales(4, 51),
      new Sales(5, 60),
    ];

    var linesalesdata2 = [
      new Sales(0, 20),
      new Sales(1, 24),
      new Sales(2, 25),
      new Sales(3, 40),
      new Sales(4, 45),
      new Sales(5, 60),
    ];
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

    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xffff9900)),
        id: 'Air Pollution',
        data: linesalesdata2,
        domainFn: (Sales sales, _) => sales.yearval,
        measureFn: (Sales sales, _) => sales.salesval,
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
            backgroundColor: Color(0xff1976d2),
            //backgroundColor: Color(0xff308e1c),
            bottom: TabBar(
              indicatorColor: Color(0xff9962D0),
              tabs: [
                Tab(
                  icon: Icon(FontAwesomeIcons.solidChartBar),
                ),
                Tab(icon: Icon(FontAwesomeIcons.flag)),
                Tab(icon: Icon(FontAwesomeIcons.chartLine)),
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
                  itemCount: num == null ? 0 : num.length,
                  itemBuilder: (BuildContext context, int index) {
                    COVIDByCountry covidByCountr = num[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundImage: NetworkImage(covidByCountr.flag),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                "${covidByCountr.country} \n Total Case: ${covidByCountr.total_cases} \n "
                                " New Case: ${covidByCountr.new_cases} \n"
                                " Total Death: ${covidByCountr.total_deaths}",
                                style: TextStyle(
                                  fontSize: 20.0,
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
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Sales for the first 5 years',
                          style: TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: charts.LineChart(_seriesLineData,
                              defaultRenderer: new charts.LineRendererConfig(
                                  includeArea: true, stacked: true),
                              animate: true,
                              animationDuration: Duration(seconds: 5),
                              behaviors: [
                                new charts.ChartTitle('Years',
                                    behaviorPosition:
                                        charts.BehaviorPosition.bottom,
                                    titleOutsideJustification: charts
                                        .OutsideJustification.middleDrawArea),
                                new charts.ChartTitle('Sales',
                                    behaviorPosition:
                                        charts.BehaviorPosition.start,
                                    titleOutsideJustification: charts
                                        .OutsideJustification.middleDrawArea),
                                new charts.ChartTitle(
                                  'Departments',
                                  behaviorPosition: charts.BehaviorPosition.end,
                                  titleOutsideJustification: charts
                                      .OutsideJustification.middleDrawArea,
                                )
                              ]),
                        ),
                      ],
                    ),
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

class Sales {
  int yearval;
  int salesval;

  Sales(this.yearval, this.salesval);
}
