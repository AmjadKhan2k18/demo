import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/helpers/firestore.dart';
import 'package:demo/helpers/preference_util.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class FirestoreDataState with ChangeNotifier {
  String userId;

  FirestoreDataState() {
    getUserId();
  }
  getUserId() async {
    final id = await PreferenceUtils.getString('userId');
    if (id == null) {
      var uuid = Uuid();
      var v1 = uuid.v1();
      userId = v1;
      PreferenceUtils.setString('userId', v1);
    } else {
      userId = id;
    }
    notifyListeners();
  }

  Future<DocumentReference> addFavouriteCity(Map<String, dynamic> city) async {
    return FirestoreHelper.addCity(userId, city);
  }

  Future<void> removeFavouriteCity(String docId) async {
    return FirestoreHelper.removeCity(userId, docId);
  }
}
