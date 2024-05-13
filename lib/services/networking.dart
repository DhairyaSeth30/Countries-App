import 'dart:convert';
import 'package:http/http.dart' as http;

class CountryModel{
  Future<List<Map<String, dynamic>>> fetchCountryData() async {
    final response = await http.get(Uri.parse('https://restcountries.com/v3.1/all'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load country data'); 
    }
  }
}