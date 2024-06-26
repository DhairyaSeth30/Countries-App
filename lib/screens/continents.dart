
import 'dart:convert';
import 'package:countries_app/screens/city-detail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CountryListScreen extends StatefulWidget {
  @override
  _CountryListScreenState createState() => _CountryListScreenState();
}

class _CountryListScreenState extends State<CountryListScreen> {
  late Future<List<Map<String, dynamic>>> _countryDataFuture;

  @override
  void initState() {
    super.initState();
    _countryDataFuture = _fetchCountryData();
  }

  Future<List<Map<String, dynamic>>> _fetchCountryData() async {
    final response = await http.get(Uri.parse('https://restcountries.com/v3.1/all'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load country data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Countries'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _countryDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final countries = snapshot.data!;
            final continents = Map<String, List<String>>();

            // Organize countries into continents
            for (var country in countries) {
              final String continent = country['region'];
              final String countryName = country['name']['common'];

              if (!continents.containsKey(continent)) {
                continents[continent] = [];
              }
              continents[continent]!.add(countryName);
            }

            return ListView.builder(
              itemCount: continents.length,
              itemBuilder: (context, index) {
                final continent = continents.keys.elementAt(index);
                final countries = continents[continent]!;

                return ExpansionTile(
                  title: Text(continent),
                  children: countries
                      .map((country) => ListTile(
                            title: Text(country),
                            onTap: () {
                              // Navigate to detail screen and pass country details as arguments
                              Navigator.push(context, MaterialPageRoute(builder: (context) => CityDetailsScreen(country)));
                              
                            },
                          ))
                      .toList(),
                );
              },
            );
          }
        },
      ),
    );
    
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











// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class CountryListScreen extends StatefulWidget {
//   @override
//   _CountryListScreenState createState() => _CountryListScreenState();
// }

// class _CountryListScreenState extends State<CountryListScreen> {
//   late Future<List<Map<String, dynamic>>> _countryDataFuture;
//   final TextEditingController _searchController = TextEditingController();
//   String _searchTerm = '';

//   @override
//   void initState() {
//     super.initState();
//     _countryDataFuture = _fetchCountryData();
//     _searchController.addListener(_onSearchChanged);
//   }

//   @override
//   void dispose() {
//     _searchController.removeListener(_onSearchChanged);
//     _searchController.dispose();
//     super.dispose();
//   }

//   void _onSearchChanged() {
//     setState(() {
//       _searchTerm = _searchController.text;
//     });
//   }

//   Future<List<Map<String, dynamic>>> _fetchCountryData() async {
//     final response = await http.get(Uri.parse('https://restcountries.com/v3.1/all'));

//     if (response.statusCode == 200) {
//       final List<dynamic> data = json.decode(response.body);
//       return data.map((e) => e as Map<String, dynamic>).toList();
//     } else {
//       throw Exception('Failed to load country data');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Countries'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 labelText: 'Search',
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.search),
//               ),
//             ),
//           ),
//           Expanded(
//             child: FutureBuilder<List<Map<String, dynamic>>>(
//               future: _countryDataFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 } else {
//                   final countries = snapshot.data!;
//                   final filteredCountries = countries.where((country) {
//                     final countryName = country['name']['common'].toLowerCase();
//                     return countryName.contains(_searchTerm.toLowerCase());
//                   }).toList();

//                   final continents = Map<String, List<String>>();

//                   // Organize countries into continents
//                   for (var country in filteredCountries) {
//                     final String continent = country['region'] ?? 'Unknown';
//                     final String countryName = country['name']['common'];

//                     if (!continents.containsKey(continent)) {
//                       continents[continent] = [];
//                     }
//                     continents[continent]!.add(countryName);
//                   }

//                   return ListView.builder(
//                     itemCount: continents.length,
//                     itemBuilder: (context, index) {
//                       final continent = continents.keys.elementAt(index);
//                       final countries = continents[continent]!;

//                       return ExpansionTile(
//                         title: Text(continent),
//                         children: countries
//                             .map((country) => ListTile(
//                                   title: Text(country),
//                                   onTap: () {
//                                     // Navigate to detail screen and pass country details as arguments
//                                     Navigator.push(context, MaterialPageRoute(builder: (context) => CityDetailsScreen(country)));
//                                   },
//                                 ))
//                             .toList(),
//                       );
//                     },
//                   );
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<Map<String, dynamic>> fetchCountryDetails(String countryName) async {
//     final List<Map<String, dynamic>> countries = await _fetchCountryData();

//     final country = countries.firstWhere(
//       (country) => country['name']['common'] == countryName,
//       orElse: () => throw Exception('Country not found'),
//     );

//     return country;
//   }
// }

// class CityDetailsScreen extends StatelessWidget {
//   final String countryName;

//   CityDetailsScreen(this.countryName);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(countryName),
//       ),
//       body: Center(
//         child: Text('Details for $countryName'),
//       ),
//     );
//   }
// }
