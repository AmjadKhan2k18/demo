import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/helpers/local_db.dart';
import 'package:demo/models/city.dart';
import 'package:demo/providers/firestore_data.dart';
import 'package:demo/providers/local_db.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final cities = Provider.of<LocalDbState>(context).cities;
    return Scaffold(
      appBar: AppBar(
        title: Text("Search History"),
      ),
      body: ListView.builder(
        itemCount: cities.length,
        itemBuilder: (BuildContext context, int index) {
          return CityTile(cities[index]);
        },
      ),
    );
  }
}

class CityTile extends StatelessWidget {
  final Map<String, dynamic> city;

  CityTile(this.city);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            child: Text(city['id'].toString()),
          ),
          title: Text(city['city']),
          trailing: SizedBox(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FavouriteButton(city),
                IconButton(
                  onPressed: () async {
                    await dbHelper.delete(
                      city['id'],
                      DatabaseHelper.tableName,
                      DatabaseHelper.id,
                    );
                    Provider.of<LocalDbState>(context, listen: false).getData();
                  },
                  icon: Icon(Icons.delete),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FavouriteButton extends StatefulWidget {
  final Map<String, dynamic> city;
  const FavouriteButton(this.city);

  @override
  _FavouriteButtonState createState() => _FavouriteButtonState();
}

class _FavouriteButtonState extends State<FavouriteButton> {
  @override
  Widget build(BuildContext context) {
    final cities = Provider.of<Cities>(context).cities;
    final firestoreDataState = Provider.of<FirestoreDataState>(context);

    final isFavourite = cities.firstWhere((c) => c.city == widget.city['city'],
        orElse: () => null);

    return IconButton(
      onPressed: () async {
        if (isFavourite == null) {
          DocumentReference docRef =
              await firestoreDataState.addFavouriteCity(widget.city);
          setState(() {
            cities.add(City(widget.city['id'], widget.city['city'], docRef.id));
          });
        } else {
          firestoreDataState.removeFavouriteCity(isFavourite.docId);
          setState(() {
            cities.removeWhere((city) => city == isFavourite);
          });
        }
      },
      icon: Icon(Icons.star, color: isFavourite == null ? null : Colors.yellow),
    );
  }
}
