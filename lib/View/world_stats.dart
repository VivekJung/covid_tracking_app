import 'dart:developer';

import 'package:covid_tracking_app/Model/world_state_model.dart';
import 'package:covid_tracking_app/Services/states_services.dart';
import 'package:covid_tracking_app/View/countries_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';

class WorldStatsScreen extends StatefulWidget {
  const WorldStatsScreen({Key? key}) : super(key: key);

  @override
  State<WorldStatsScreen> createState() => _WorldStatsScreenState();
}

class _WorldStatsScreenState extends State<WorldStatsScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..repeat();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  final colorList = <Color>[
    const Color(0xff4285f4),
    const Color(0xff1aa268),
    const Color(0xffde5246),
  ];

  @override
  Widget build(BuildContext context) {
    double ht = MediaQuery.of(context).size.height;
    double wt = MediaQuery.of(context).size.width;

    //getting Api data
    StatesServices statesServices = StatesServices();
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: ht * 0.02),
            FutureBuilder(
              future: statesServices.fetchWorldStat(),
              builder: (context, AsyncSnapshot<WorldStateModel> snapshot) {
                log(statesServices.fetchWorldStat().toString());
                if (!snapshot.hasData) {
                  return Expanded(
                    flex: 1,
                    child: SpinKitFadingCube(
                      color: Colors.white,
                      size: 50,
                      controller: _controller,
                    ),
                  );
                } else {
                  return Expanded(
                    child: Column(
                      children: [
                        pieChart(wt, ht, snapshot),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: ht * 0.02),
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    //part 1
                                    _todayCases(ht, snapshot),
                                    SizedBox(height: ht * 0.02),
                                    //part 2
                                    _totalCases(ht, snapshot),
                                    SizedBox(height: ht * 0.02),
                                    //PART 3
                                    _totalCasesperMillion(ht, snapshot),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CountriesListScreen()));
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            onPrimary: Colors.white,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.search_sharp),
                              SizedBox(width: 10),
                              Text('Search and track countires'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      )),
    );
  }

  Container _totalCasesperMillion(
      double ht, AsyncSnapshot<WorldStateModel> snapshot) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Card(
        child: Column(
          children: [
            SizedBox(height: ht * 0.01),
            const Text("WORLD STATUS - per one million"),
            ReusableRow(
                title: "Total Cases",
                value: snapshot.data!.casesPerOneMillion.toString()),
            ReusableRow(
                title: 'Active Cases',
                value: snapshot.data!.activePerOneMillion.toString()),
            ReusableRow(
                title: 'Total recoverd',
                value: snapshot.data!.recoveredPerOneMillion.toString()),
            ReusableRow(
                title: 'In critical',
                value: snapshot.data!.criticalPerOneMillion.toString()),
            ReusableRow(
                title: 'Total deaths',
                value: snapshot.data!.deathsPerOneMillion.toString()),
          ],
        ),
      ),
    );
  }

  Container _totalCases(double ht, AsyncSnapshot<WorldStateModel> snapshot) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Card(
        child: Column(
          children: [
            SizedBox(height: ht * 0.01),
            const Text("WORLD STATUS"),
            ReusableRow(
                title: "Total Cases", value: snapshot.data!.cases.toString()),
            ReusableRow(
                title: 'Active Cases', value: snapshot.data!.active.toString()),
            ReusableRow(
                title: 'Total recoverd',
                value: snapshot.data!.recovered.toString()),
            ReusableRow(
                title: 'In critical',
                value: snapshot.data!.critical.toString()),
            ReusableRow(
                title: 'Total deaths', value: snapshot.data!.deaths.toString()),
            ReusableRow(
                title: 'Affected Countires',
                value: snapshot.data!.affectedCountries.toString()),
          ],
        ),
      ),
    );
  }

  Container _todayCases(double ht, AsyncSnapshot<WorldStateModel> snapshot) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Card(
        child: Column(
          children: [
            SizedBox(height: ht * 0.01),
            const Text("TODAY'S STATUS"),
            ReusableRow(
                title: "Total today's Cases",
                value: snapshot.data!.todayCases.toString()),
            ReusableRow(
                title: 'Recoverd Today',
                value: snapshot.data!.todayRecovered.toString()),
            ReusableRow(
                title: 'Deaths Today',
                value: snapshot.data!.todayDeaths.toString()),
          ],
        ),
      ),
    );
  }

  pieChart(double wt, double ht, AsyncSnapshot<WorldStateModel> snapshot) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ht * 0.02),
      child: PieChart(
        dataMap: {
          "Total": double.parse(snapshot.data!.cases!.toString()),
          "Recovered": double.parse(snapshot.data!.recovered!.toString()),
          "Deaths": double.parse(snapshot.data!.deaths!.toString()),
        },
        chartValuesOptions:
            const ChartValuesOptions(showChartValuesInPercentage: true),
        chartRadius: wt / 3,
        legendOptions: const LegendOptions(
          legendPosition: LegendPosition.left,
        ),
        animationDuration: const Duration(milliseconds: 1200),
        chartType: ChartType.ring,
        colorList: colorList,
      ),
    );
  }
}

class ReusableRow extends StatelessWidget {
  final String title, value;
  const ReusableRow({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Text(value),
            ],
          ),
        ],
      ),
    );
  }
}
