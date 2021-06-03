import 'package:demo/helpers/http_service.dart';
import 'package:demo/helpers/local_db.dart';
import 'package:demo/helpers/preference_util.dart';
import 'package:demo/models/weather.dart';
import 'package:demo/providers/local_db.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class WeatherDataState with ChangeNotifier {
  WeatherModel weather;

  Future<String> getFinalWeather() async {
    final city = await PreferenceUtils.getString('finalSearch') ?? "London";
    return city;
  }

  setFinalWeather(String value) {
    PreferenceUtils.setString('finalSearch', value);
  }

  getWeatherData(
    String city,
    String apiKey,
    BuildContext context, {
    bool isNotFinal = true,
  }) async {
    final response = await HttpService.getRequest(
      city: city,
      apiKey: apiKey,
    );

    switch (response['cod']) {
      case 200:
        Toast.show(
          'Successfully',
          context,
          gravity: 0,
        );
        weather = WeatherModel.fromJson(response);
        if (isNotFinal) setFinalWeather(city);
        if (isNotFinal) checkAndInsertInLocalDB(city, context);
        break;

      default:
        Toast.show(
          response['message'].toUpperCase(),
          context,
          gravity: 1,
        );
        break;
    }
    notifyListeners();
  }

  checkAndInsertInLocalDB(String newCity, BuildContext context) async {
    final result = await dbHelper.customSearch(
      columns: [DatabaseHelper.city],
      tableName: DatabaseHelper.tableName,
      where: DatabaseHelper.city,
      whereArgs: [newCity.toUpperCase()],
    );

    if (result.length == 0) {
      await dbHelper.insert({DatabaseHelper.city: newCity.toUpperCase()},
          DatabaseHelper.tableName);
      Provider.of<LocalDbState>(context, listen: false).getData();
    }
  }
}
