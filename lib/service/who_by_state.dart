import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class APIService {
  APIService._instantiate();

  static final APIService instance = APIService._instantiate();

  String baseUrl =
      "https://corona-virus-stats.herokuapp.com/api/v1/cases/countries-search?limit=20&page=1";
  fetchByCountries() async {
    Uri uri = Uri.https(
      "",
      baseUrl,
    );

    var response = await http.get(uri);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body)['data'][0];
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }
}
