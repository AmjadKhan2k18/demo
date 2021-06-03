import 'dart:async';

import 'package:demo/models/weather.dart';
import 'package:demo/providers/firebase_config.dart';
import 'package:demo/providers/local_db.dart';
import 'package:demo/providers/weather.dart';
import 'package:demo/screens/history.dart';
import 'package:demo/widgets/our_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    getFinalSearch();
    super.initState();
  }

  getFinalSearch() async {
    final weatherDataState = Provider.of<WeatherDataState>(
      context,
      listen: false,
    );
    final apiKey = Provider.of<FirebaseConfigState>(
      context,
      listen: false,
    ).apiKey;
    final city = await weatherDataState.getFinalWeather();
    weatherDataState.getWeatherData(city, apiKey, context, isNotFinal: false);
  }

  @override
  Widget build(BuildContext context) {
    final weatherDataState = Provider.of<WeatherDataState>(
      context,
    );

    return weatherDataState.weather == null
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text('Weather Demo'),
              actions: [
                IconButton(
                  icon: Icon(Icons.history),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => HistoryScreen(),
                    ),
                  ),
                ),
              ],
            ),
            body: WeatherScreen(),
          );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  TextEditingController controller = TextEditingController();

  var searchItems = List<Map>();

  Timer debouncer;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void filterSearchResults(
    String query,
    List<Map<String, dynamic>> cities,
  ) {
    List<Map> dummySearchList = cities;
    if (query.isNotEmpty) {
      List<Map> dummyListData = List<Map>();
      dummySearchList.forEach((item) {
        if (item['city'].contains(query.toUpperCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        searchItems.clear();
        searchItems.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        searchItems.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final weatherState = Provider.of<WeatherDataState>(context);
    final apiKey = Provider.of<FirebaseConfigState>(context).apiKey;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(
                controller: controller,
                onChanged: (value) {
                  if (value.isEmpty) {
                    setState(() => searchItems.clear());
                    return;
                  }

                  if (debouncer != null && debouncer.isActive)
                    debouncer.cancel();

                  debouncer = Timer(Duration(milliseconds: 500), () {
                    filterSearchResults(
                        value,
                        Provider.of<LocalDbState>(
                          context,
                          listen: false,
                        ).cities);
                  });
                },
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  labelText: "Search city",
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () async {
                      weatherState.getWeatherData(
                          controller.text, apiKey, context);
                    },
                    icon: Icon(Icons.search),
                  ),
                ),
              ),
              SizedBox(height: 100),
              cityView(weatherState.weather),
              SizedBox(height: 50),
              weatherView(weatherState.weather),
            ],
          ),
          Positioned(
              top: size.height * 0.08,
              child: Container(
                height: size.height * 0.4,
                width: size.width,
                child: ListView.builder(
                  itemCount: searchItems.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        weatherState.getWeatherData(
                          searchItems[index]['city'],
                          apiKey,
                          context,
                        );
                        setState(() {
                          searchItems.clear();
                          controller.clear();
                        });
                      },
                      child: Card(
                        child: ListTile(
                          title: Text(searchItems[index]['city']),
                        ),
                      ),
                    );
                  },
                ),
              )),
        ],
      ),
    );
  }

  Widget weatherView(WeatherModel weather) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Text(
              '${weather.main.temp}°ᶜ',
              style: TextStyle(
                fontSize: 50,
                // color: Colors.white,
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              'Feels like ${weather.main.feelsLike}°ᶜ',
              style: TextStyle(
                fontSize: 18,
                // color: Colors.white,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget cityView(WeatherModel weather) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Text('${weather.name.toUpperCase()}',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w300,
          )),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_on, color: Colors.white, size: 15),
          SizedBox(width: 10),
          Text(weather.coord.lat.toString(),
              style: TextStyle(
                fontSize: 16,
              )),
          Text(' , ',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              )),
          Text(weather.coord.lon.toString(),
              style: TextStyle(
                fontSize: 16,
              )),
        ],
      )
    ]);
  }
}
