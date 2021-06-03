import 'package:cloud_firestore/cloud_firestore.dart';

class City {
  int id;
  String city;
  String docId;

  City(this.id, this.city, this.docId);

  factory City.fromDocument(DocumentSnapshot doc) {
    final docData = doc.data();
    print(docData['city']);
    return City(docData['id'], docData['city'], doc.id);
  }
}

class Cities {
  List<City> cities;
  Cities(this.cities);
}
