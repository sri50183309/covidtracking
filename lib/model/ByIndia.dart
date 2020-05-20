import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class COVIDInIndia {
  final String state; //country
  final int confirmed;
  final int death_rate;
  final int active_rate; //new_cases

  COVIDInIndia(this.state, this.confirmed, this.death_rate, this.active_rate);

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
        element['death_rate'], element['active_rate']);
  }
}
