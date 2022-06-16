import 'dart:developer';

import 'package:covid_tracking_app/View/world_stats.dart';
import 'package:flutter/material.dart';

class CountryInfoScreen extends StatefulWidget {
  final List? snapData;
  final int index;
  const CountryInfoScreen({Key? key, required this.index, this.snapData})
      : super(key: key);

  @override
  State<CountryInfoScreen> createState() => _CountryInfoScreenState();
}

class _CountryInfoScreenState extends State<CountryInfoScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var snapInfo = widget.snapData![widget.index];
    log('$snapInfo');
    return Scaffold(
      appBar: AppBar(
        title: Text(snapInfo['country'].toString()),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: height * 0.25,
              width: width,
              color: Colors.transparent,
              child: Image.network(
                snapInfo['countryInfo']['flag'].toString(),
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                color: Colors.transparent,
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      //part 1
                      _countryDetails(snapInfo),
                      const SizedBox(height: 20),
                      //part 2
                      _currentCovidStatus(snapInfo),
                      const SizedBox(height: 20),
                      //part3
                      _todaysCovidStatus(snapInfo),
                    ],
                  ),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }

  _currentCovidStatus(snapInfo) {
    return SingleChildScrollView(
      child: Card(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text('CURRENT CASE STATUS'),
            ReusableRow(
              title: 'Cases',
              value: snapInfo['cases'].toString(),
            ),
            ReusableRow(
              title: 'Deaths',
              value: snapInfo['deaths'].toString(),
            ),
            ReusableRow(
              title: 'Recovered',
              value: snapInfo['recovered'].toString(),
            ),
            ReusableRow(
              title: 'Active',
              value: snapInfo['active'].toString(),
            ),
            ReusableRow(
              title: 'Critical',
              value: snapInfo['critical'].toString(),
            ),
            ReusableRow(
              title: 'Tested',
              value: snapInfo['tests'].toString(),
            ),
          ],
        ),
      ),
    );
  }

  _countryDetails(snapInfo) {
    return SingleChildScrollView(
      child: Card(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text('COUNTRY DETAILS'),
            ReusableRow(
              title: 'Country',
              value: snapInfo['country'].toString(),
            ),
            ReusableRow(
              title: 'Continent',
              value: snapInfo['continent'].toString(),
            ),
            ReusableRow(
              title: 'Population',
              value: snapInfo['population'].toString(),
            ),
            ReusableRow(
              title: 'Reg ID',
              value: snapInfo['countryInfo']['_id'].toString(),
            ),
            ReusableRow(
              title: 'Latitude',
              value: snapInfo['countryInfo']['lat'].toString(),
            ),
            ReusableRow(
              title: 'Longitude',
              value: snapInfo['countryInfo']['long'].toString(),
            ),
          ],
        ),
      ),
    );
  }

  _todaysCovidStatus(snapInfo) {
    return SingleChildScrollView(
      child: Card(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text("TODAY'S STATUS"),
            ReusableRow(
              title: 'Cases',
              value: snapInfo['todayCases'].toString(),
            ),
            ReusableRow(
              title: 'Deaths',
              value: snapInfo['todayDeaths'].toString(),
            ),
            ReusableRow(
              title: 'Recovered',
              value: snapInfo['todayRecovered'].toString(),
            ),
          ],
        ),
      ),
    );
  }
}
