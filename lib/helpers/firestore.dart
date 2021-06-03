import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/models/city.dart';

class FirestoreHelper {
  static final _firestore = FirebaseFirestore.instance;

  static final _usersRef = _firestore.collection('users');

  static CollectionReference _userCities(String userId) {
    print('userId in _userCities $userId');
    return _usersRef.doc(userId).collection('cities');
  }

  static Future<Cities> getCitiesStream(String userId) {
    if (userId == null) return Future.value(null);
    return _userCities(userId).orderBy('id').get().then((querySnap) =>
        Cities(querySnap.docs.map((doc) => City.fromDocument(doc)).toList()));
  }

  static Future<DocumentReference> addCity(
      String userId, Map<String, dynamic> city) async {
    return _userCities(userId).add(city);
  }

  static Future<void> removeCity(String userId, cityId) async {
    return _userCities(userId).doc(cityId).delete();
  }
}
