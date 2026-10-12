import 'dart:convert';

import 'package:http/http.dart' as http;

class DestinationService {
  static const String _overpassUrl =
      'https://overpass-api.de/api/interpreter';

  /// Fetches tourism attractions from OpenStreetMap
  /// for the given destination.
  static Future<List<Map<String, dynamic>>> fetchAttractions(
    String destination,
  ) async {
    final query = '''
[out:json][timeout:25];

area["name"="$destination"]->.searchArea;

(
  node["tourism"="attraction"](area.searchArea);
  way["tourism"="attraction"](area.searchArea);
  relation["tourism"="attraction"](area.searchArea);
);

out center tags;
''';

    try {
      final response = await http.post(
        Uri.parse(_overpassUrl),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'data': query,
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to fetch attractions. '
          'Status code: ${response.statusCode}',
        );
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      final elements = data['elements'];

      if (elements is! List) {
        return [];
      }

      final attractions = <Map<String, dynamic>>[];

      for (final element in elements) {
        if (element is! Map<String, dynamic>) {
          continue;
        }

        final tags = element['tags'];

        if (tags is! Map<String, dynamic>) {
          continue;
        }

        final name = tags['name'];

        if (name == null || name.toString().trim().isEmpty) {
          continue;
        }

        double? latitude;
        double? longitude;

        // Nodes have lat/lon directly.
        if (element['lat'] != null && element['lon'] != null) {
          latitude = (element['lat'] as num).toDouble();
          longitude = (element['lon'] as num).toDouble();
        }

        // Ways/relations returned with "center" have coordinates here.
        final center = element['center'];

        if (latitude == null &&
            center is Map<String, dynamic> &&
            center['lat'] != null &&
            center['lon'] != null) {
          latitude = (center['lat'] as num).toDouble();
          longitude = (center['lon'] as num).toDouble();
        }

        attractions.add({
          'name': name.toString(),
          'latitude': latitude,
          'longitude': longitude,
          'category': tags['attraction']?.toString() ??
              tags['natural']?.toString() ??
              tags['historic']?.toString() ??
              tags['tourism']?.toString() ??
              'attraction',
          'description': tags['description']?.toString(),
          'website': tags['website']?.toString(),
          'openingHours': tags['opening_hours']?.toString(),
        });
      }

      return attractions;
    } catch (e) {
      throw Exception('Unable to fetch attractions: $e');
    }
  }
}