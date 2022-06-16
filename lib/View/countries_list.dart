import 'package:covid_tracking_app/Services/states_services.dart';
import 'package:covid_tracking_app/View/country_info.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CountriesListScreen extends StatefulWidget {
  const CountriesListScreen({Key? key}) : super(key: key);

  @override
  State<CountriesListScreen> createState() => _CountriesListScreenState();
}

class _CountriesListScreenState extends State<CountriesListScreen> {
  TextEditingController searchController = TextEditingController();

  var data = [];
  StatesServices statesServices = StatesServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(
          child: Column(
        children: [
          //search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: searchController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                hintText: "Which country would you like to search ?",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
              ),
            ),
          ),
          //contents
          Expanded(
            child: FutureBuilder(
              future: statesServices.fetchCountriesListApi(),
              builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                // log("$snapshot countries list");
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      String countryName =
                          snapshot.data![index]['country'].toString();
                      if (searchController.text.isEmpty) {
                        return ListTile(
                          leading: Image(
                            height: 50,
                            width: 50,
                            fit: BoxFit.contain,
                            image: NetworkImage(
                                snapshot.data![index]['countryInfo']['flag']),
                          ),
                          title: Text('${snapshot.data![index]['country']}'),
                          subtitle: Text('${snapshot.data![index]['cases']}'),
                          trailing: IconButton(
                              onPressed: () {
                                var snapData = snapshot.data;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            CountryInfoScreen(
                                              snapData: snapData,
                                              index: index,
                                            ))));
                              },
                              icon: const Icon(Icons.explore)),
                        );
                      } else if (countryName
                          .toLowerCase()
                          .contains(searchController.text.toLowerCase())) {
                        return ListTile(
                          leading: Image(
                            height: 50,
                            width: 50,
                            fit: BoxFit.contain,
                            image: NetworkImage(
                                snapshot.data![index]['countryInfo']['flag']),
                          ),
                          title: Text('${snapshot.data![index]['country']}'),
                          subtitle: Text('${snapshot.data![index]['cases']}'),
                          trailing: IconButton(
                              onPressed: () {
                                var snapData = snapshot.data;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            CountryInfoScreen(
                                              snapData: snapData,
                                              index: index,
                                            ))));
                              },
                              icon: const Icon(Icons.explore)),
                        );
                      } else {
                        return Container();
                      }
                    },
                  );
                } else {
                  return ListView.builder(
                    itemCount: 20,
                    itemBuilder: (context, index) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey.shade700,
                        highlightColor: Colors.grey.shade100,
                        child: ListTile(
                          title: Container(
                              width: 90, height: 12, color: Colors.white),
                          subtitle: Container(
                              width: 50, height: 8, color: Colors.white),
                          leading: Container(
                              width: 50, height: 40, color: Colors.white),
                          trailing: Container(
                              width: 20, height: 20, color: Colors.white),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      )),
    );
  }
}
