import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class FirebaseConfigState with ChangeNotifier {
  RemoteConfig remoteConfig;
  String apiKey;

  FirebaseConfigState() {
    init();
  }

  Future<void> init() async {
    remoteConfig = await RemoteConfig.instance;
    await remoteConfig.fetch(expiration: const Duration(seconds: 0));
    await remoteConfig.activateFetched();
    getRemoteValues();
  }

  void getRemoteValues() {
    final allValues = remoteConfig.getAll();
    apiKey = allValues['API'].asString();
    notifyListeners();
  }
}
