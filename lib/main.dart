import 'package:demo/models/city.dart';
import 'package:demo/providers/firebase_config.dart';
import 'package:demo/providers/firestore_data.dart';
import 'package:demo/providers/local_db.dart';
import 'package:demo/providers/weather.dart';
import 'package:demo/screens/home.dart';
import 'package:demo/widgets/our_loading.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'helpers/firestore.dart';
import 'helpers/preference_util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  PreferenceUtils.init();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: FirebaseConfigState()),
      ChangeNotifierProvider.value(value: WeatherDataState()),
      ChangeNotifierProvider.value(value: LocalDbState()),
      ChangeNotifierProvider.value(value: FirestoreDataState()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final apiKey = Provider.of<FirebaseConfigState>(context).apiKey;
    final userId = Provider.of<FirestoreDataState>(context).userId;

    return MultiProvider(
      providers: [
        FutureProvider<Cities>.value(
          value: FirestoreHelper.getCitiesStream(userId),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: apiKey == null ? Loading() : Home(),
      ),
    );
  }
}
