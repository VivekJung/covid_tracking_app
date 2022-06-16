import 'dart:developer';

import 'package:covid_tracking_app/Model/world_state_model.dart';
import 'package:covid_tracking_app/Services/Utilities/app_url.dart';
import 'package:http/http.dart' as http;

class StatesServices {
  Future<WorldStateModel> fetchWorldStat() async {
    final response = await http.get(Uri.parse(AppUrl.worldStatesApi));

    if (response.statusCode == 200) {
      var data = response.body.toString();
      log('Fetching api ok');
      return WorldStateModel.fromJson(data);
    } else {
      throw UnimplementedError();
    }
  }
}
