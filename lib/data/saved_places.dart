import 'package:flutter/material.dart';

class SavedPlaces {
  static final List<Map<String, dynamic>> places = [];

  // Used to notify the Saved screen whenever the list changes.
  static final ValueNotifier<int> version = ValueNotifier<int>(0);

  static void addPlace({
    required String name,
    required String subtitle,
    required IconData icon,
  }) {
    final alreadySaved = places.any(
      (place) => place['name'] == name,
    );

    if (!alreadySaved) {
      places.add({
        'name': name,
        'subtitle': subtitle,
        'icon': icon,
      });

      // Tell the Saved screen to refresh.
      version.value++;
    }
  }

  static void removePlace(String name) {
    final oldLength = places.length;

    places.removeWhere(
      (place) => place['name'] == name,
    );

    if (places.length != oldLength) {
      version.value++;
    }
  }

  static void clearAll() {
    if (places.isNotEmpty) {
      places.clear();

      // Tell the Saved screen to refresh.
      version.value++;
    }
  }
}