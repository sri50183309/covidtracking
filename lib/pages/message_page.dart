import 'package:covidtracker/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:covidtracker/model/ByCountry.dart';
import 'package:covidtracker/model/ByIndia.dart';
import 'package:covidtracker/model/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class MessagesPage extends StatelessWidget with NavigationStates {
  final Function onMenuTap;

  Future<List> getIndiaStatistics() async {
    http.Response response = await http.get(Constants.COVID_sTATS_IN_INDIA);
    return COVIDInIndia.byTotalCases(json.decode(response.body));
  }

  const MessagesPage({Key key, this.onMenuTap}) : super(key: key);

  DataRow _getDataRow(COVIDInIndia result) {
    return DataRow(
      cells: <DataCell>[
        DataCell(Text(
          result.state,
          style: TextStyle(
              fontStyle: FontStyle.normal, color: Colors.white, fontSize: 15),
        )),
        DataCell(Text(
          "${result.confirmed}",
          style: TextStyle(
              fontStyle: FontStyle.normal, color: Colors.white, fontSize: 20),
        )),
        DataCell(Text(
          "${result.deaths}",
          style: TextStyle(
              fontStyle: FontStyle.normal, color: Colors.white, fontSize: 20),
        )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(1)),
      ),
      padding: const EdgeInsets.only(left: 16, right: 16, top: 48),
      child: SingleChildScrollView(
        child: FutureBuilder(
          future: Future.wait([getIndiaStatistics()]),
          builder: (context, AsyncSnapshot<List> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.cyanAccent,
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                  strokeWidth: 2,
                ),
              );
            } else {
              List covidInIndia = snapshot.data[0];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                verticalDirection: VerticalDirection.down,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      InkWell(
                        child: Icon(Icons.menu, color: Colors.white),
                        onTap: onMenuTap,
                      ),
                      Text("Covid in India",
                          style: TextStyle(fontSize: 24, color: Colors.white)),
                      Icon(Icons.settings, color: Colors.white70),
                    ],
                  ),
                  DataTable(
                    columnSpacing: 2,
                    dividerThickness: 5,
                    columns: [
                      DataColumn(
                        label: Text('State',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.white)),
                      ),
                      DataColumn(
                        label: Text('Confirmed',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.white)),
                      ),
                      DataColumn(
                        label: Text('Death',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.white)),
                      ),
                    ],
                    rows: List.generate(covidInIndia.length,
                        (index) => _getDataRow(covidInIndia[index])),
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
