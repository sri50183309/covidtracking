import 'package:covidtracker/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyCardsPage extends StatelessWidget with NavigationStates {
  final Function onMenuTap;

  const MyCardsPage({Key key, this.onMenuTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 1,
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(40)),
            color: Colors.redAccent,
          ),
          padding: const EdgeInsets.only(left: 16, right: 16, top: 48),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  InkWell(
                    child: Icon(Icons.menu, color: Colors.white),
                    onTap: onMenuTap,
                  ),
                  Text("My Cards",
                      style: TextStyle(fontSize: 24, color: Colors.white)),
                  Icon(Icons.settings, color: Colors.white),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  TabBar(
                    indicatorColor: Color(0xff9962D0),
                    tabs: [
                      Tab(
                        icon: Icon(FontAwesomeIcons.solidChartBar),
                      ),
                      Tab(
                        icon: Icon(FontAwesomeIcons.globe),
                      ),
                    ],
                  ),
                ],
              )
            ],
          )),
    );
  }
}
