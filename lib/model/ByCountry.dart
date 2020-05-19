import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class COVIDByCountry {
  final String country; //country
  final int total_cases; //total_cases
  Color colorval;

  COVIDByCountry(this.country, this.total_cases, this.colorval);

  static byTotalCases(Map userData) {
    List<COVIDByCountry> byTotalCases = [];

    if (userData != null) {
      List<dynamic> covidResponseByCountries = userData['data']['rows'];
      List colors = [
        Colors.red,
        Colors.green,
        Colors.yellow,
        Colors.blue,
        Colors.purple
      ];
      Random random = new Random();

      int index = 0;
      int i = 0;
      covidResponseByCountries.forEach((element) {
        index = random.nextInt(5);
        if (i <= 10 && element['country_abbreviation'] != '') {
          byTotalCases.add(fromTotalCases(element, colors[index]));
        }
        i++;
      });
    }
    return byTotalCases;
  }

  static fromTotalCases(element, color) {
    return new COVIDByCountry(
        element['country_abbreviation'],
        int.parse(element['total_cases'].toString().replaceAll(",", "")),
        color);
  } //flag

}
