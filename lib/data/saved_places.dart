import 'package:flutter/material.dart';

class SavedPlaces {
  static final List<Map<String, dynamic>> places = [];

  static void addPlace({
    required String name,
    required String subtitle,
    required IconData icon,
  }) {
    final alreadySaved = places.any((place) => place['name'] == name);

    if (!alreadySaved) {
      places.add({'name': name, 'subtitle': subtitle, 'icon': icon});
    }
  }

  static void removePlace(String name) {
    places.removeWhere((place) => place['name'] == name);
  }
}
