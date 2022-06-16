import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

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
    var snapInfo = widget.snapData![widget.index];
    log('$snapInfo');
    return Scaffold(
      appBar: AppBar(title: Text(snapInfo['country'].toString())),
      body: ListTile(
        title: Text(snapInfo['countryInfo']['lat'].toString()),
      ),
    );
  }
}
