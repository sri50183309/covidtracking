class COVIDByCountry {
  final String country; //country
  final int total_cases; //total_cases

  COVIDByCountry(this.country, this.total_cases);

  static byTotalCases(Map userData) {
    List<COVIDByCountry> byTotalCases = [];

    if (userData != null) {
      List<dynamic> covidResponseByCountries = userData['data']['rows'];

      int i = 0;
      covidResponseByCountries.forEach((element) {
        if (i <= 10 && element['country_abbreviation'] != '') {
          byTotalCases.add(fromTotalCases(element));
        }
        i++;
      });
    }
    return byTotalCases;
  }

  static byNewCases(Map userData) {
    return [
      new COVIDByCountry('World', 4000000),
      new COVIDByCountry('USA', 1000000),
      new COVIDByCountry('India', 1000000),
    ];
  }

  static fromTotalCases(element) {
    return new COVIDByCountry(element['country_abbreviation'],
        int.parse(element['total_cases'].toString().replaceAll(",", "")));
  } //flag

//  factory COVIDByCountry.fromMap(Map<String, dynamic> map) {
//    map.forEach((key, value) {});
//    return COVIDByCountry(
//      country: map['country'],
//      total_cases: map['total_cases'],
//      new_cases: map['new_cases'],
//      total_deaths: map['total_deaths'],
//      new_deaths: map['new_deaths'],
//      flag: map['flag'],
//    );
  //}
}
