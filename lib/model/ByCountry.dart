import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class COVIDByCountry {
  final String country; //country
  final int total_cases; //total_cases
  Color colorval;
  final String flag;
  final String new_cases; //new_cases
  final String total_deaths; //total_deaths
  final String new_deaths; //new_deaths
  final String country_abbreviation;
  final String totalCasesString;

  COVIDByCountry(
      this.country,
      this.total_cases,
      this.colorval,
      this.flag,
      this.new_cases,
      this.total_deaths,
      this.new_deaths,
      this.country_abbreviation,
      this.totalCasesString);

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
        if (i <= 15 && element['country_abbreviation'] != '') {
          byTotalCases.add(fromTotalCases(element, colors[index]));
        }
        i++;
      });
    }
    return byTotalCases;
  }

  static fromTotalCases(element, color) {
    return new COVIDByCountry(
        element['country'],
        int.parse(element['total_cases'].toString().replaceAll(",", "")),
        color,
        element['flag'],
        element['new_cases'],
        element['total_deaths'],
        element['new_deaths'],
        element['country_abbreviation'],
        element['total_cases']);
  } //flag

}
