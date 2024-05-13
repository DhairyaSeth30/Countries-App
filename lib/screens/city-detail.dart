import 'package:countries_app/utility/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CityDetailsScreen extends StatefulWidget {
  CityDetailsScreen(this.country);

  final country;

  @override
  State<CityDetailsScreen> createState() => _CityDetailsScreenState();
}

class _CityDetailsScreenState extends State<CityDetailsScreen> {
  String? name;
  String? capital;
  String? continent;
  int? population;
  String? region;
  String? subRegion;
  String? flag;
  
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetching();
  }

  Future<List<Map<String, dynamic>>> _fetchCountryData() async {
    final response =
        await http.get(Uri.parse('https://restcountries.com/v3.1/all'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load country data');
    }
  }

  void fetching() {
    fetchCountryDetails(widget.country).then((countryDetails) {
      
      name = countryDetails['name']['common'];// name of country
      capital = countryDetails['capital'][0];
      continent = countryDetails['continents'][0];
      population = countryDetails['population'];
      region = countryDetails['region'];
      subRegion = countryDetails['subregion'];
      flag = countryDetails['flags']['png'];

      setState(() {
        isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Country Info'),
        ),
        body:
            isLoading ? Center(child: CircularProgressIndicator()) : Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10,),
                  Text(
                    'Country Flag',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    width: 150,
                    height: 120,
                    child: Image.network('$flag'),
                  ),
                  Text(
                    'Country Name : $name',
                    style: kTextStyle,
                  ),
                  SizedBox(height: 10,),
                  Text(
                    'Continent : $continent',
                    style: kTextStyle,
                  ),
                  SizedBox(height: 10,),
                  Text(
                    'Capital : $capital',
                    style: kTextStyle,
                  ),
                  SizedBox(height: 10,),
                  Text(
                    'Population : $population',
                    style: kTextStyle,
                  ),
                  SizedBox(height: 10,),
                  Text(
                    'Region : $region',
                    style: kTextStyle,
                  ),
                  SizedBox(height: 10,),
                  Text(
                    'Sub-Region : $subRegion',
                    style: kTextStyle,
                  ),

                ],
              ),
            ));
  }

  Future<Map<String, dynamic>> fetchCountryDetails(String countryName) async {
    final List<Map<String, dynamic>> countries = await _fetchCountryData();

    final country = countries.firstWhere(
      (country) => country['name']['common'] == countryName,
      orElse: () => throw Exception('Country not found'),
    );

    return country;
  }
}




