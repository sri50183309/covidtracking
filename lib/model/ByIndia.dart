import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class COVIDInIndia {
  final String state; //country
  final int confirmed;
  final int deaths;
  final int recovered; //new_cases

  COVIDInIndia(this.state, this.confirmed, this.deaths, this.recovered);

  static byTotalCases(Map userData) {
    List<COVIDInIndia> byTotalCases = [];
    if (userData != null) {
      List<dynamic> covidResponseByCountries = userData['state_data'];
      covidResponseByCountries.forEach((element) {
        byTotalCases.add(fromTotalCases(element));
      });
    }
    return byTotalCases;
  }

  static fromTotalCases(element) {
    return new COVIDInIndia(element['state'], element['confirmed'],
        element['deaths'], element['recovered']);
  }
}
