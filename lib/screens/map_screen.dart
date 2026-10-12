import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // ============================================================
  // MAP
  // ============================================================

  final MapController mapController = MapController();

  final LatLng initialLocation = const LatLng(
    18.5204,
    73.8567,
  );

  // ============================================================
  // CURRENT LOCATION
  // ============================================================

  LatLng? currentLocation;

  // ============================================================
  // START LOCATION
  // ============================================================

  final TextEditingController originController =
      TextEditingController();

  LatLng? selectedOrigin;

  String? originName;

  // ============================================================
  // DESTINATION
  // ============================================================

  final TextEditingController destinationController =
      TextEditingController();

  LatLng? selectedDestination;

  String? destinationName;

  // ============================================================
  // SEARCH
  // ============================================================

  List<dynamic> searchResults = [];

  bool isSearching = false;

  String activeSearchField = '';

  // ============================================================
  // ROUTE
  // ============================================================

  List<LatLng> routePoints = [];

  double? routeDistance;

  double? routeDuration;

  bool isRouting = false;

  // ============================================================
  // TRAVEL MODE
  // ============================================================

  String? selectedTravelMode;

  // ============================================================
  // COLORS
  // ============================================================

  static const Color primaryBlue = Color(0xFF1565C0);
  static const Color darkBlue = Color(0xFF0D47A1);
  static const Color lightBlue = Color(0xFFE3F2FD);
  static const Color background = Color(0xFFF5F9FE);
  static const Color green = Color(0xFF2E7D32);
  static const Color red = Color(0xFFE53935);

  // ============================================================
  // CURRENT LOCATION
  // ============================================================

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled =
        await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Location services are disabled. Please turn on GPS.',
          ),
        ),
      );

      return;
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission =
          await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Location permission was denied.',
            ),
          ),
        );

        return;
      }
    }

    if (permission ==
        LocationPermission.deniedForever) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Location permission is permanently denied. '
            'Please enable it from app settings.',
          ),
        ),
      );

      return;
    }

    try {
      Position position =
          await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final LatLng userLocation = LatLng(
        position.latitude,
        position.longitude,
      );

      if (!mounted) return;

      setState(() {
        currentLocation = userLocation;
        selectedOrigin = userLocation;
        originName = 'My current location';
        originController.text =
            'My current location';
      });

      mapController.move(
        userLocation,
        15,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to get your location: $e',
          ),
        ),
      );
    }
  }

  // ============================================================
  // SEARCH PLACES
  // ============================================================

  Future<void> searchPlaces(
    String query,
    String searchField,
  ) async {
    if (query.trim().isEmpty) {
      setState(() {
        searchResults = [];
        activeSearchField = '';
      });

      return;
    }

    setState(() {
      isSearching = true;
      activeSearchField = searchField;
    });

    try {
      final Uri url = Uri.parse(
        'https://nominatim.openstreetmap.org/search'
        '?format=jsonv2'
        '&limit=5'
        '&q=${Uri.encodeQueryComponent(query)}',
      );

      final response = await http
          .get(
            url,
            headers: {
              'User-Agent':
                  'Saarthi/1.0 (com.example.newproject)',
              'Accept-Language': 'en',
            },
          )
          .timeout(
            const Duration(seconds: 15),
          );

      if (response.statusCode == 200) {
        final List<dynamic> data =
            jsonDecode(response.body);

        if (!mounted) return;

        setState(() {
          searchResults = data;
          isSearching = false;
        });
      } else {
        if (!mounted) return;

        setState(() {
          searchResults = [];
          isSearching = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Unable to search for this place.',
            ),
          ),
        );
      }
    } on TimeoutException {
      if (!mounted) return;

      setState(() {
        searchResults = [];
        isSearching = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Search took too long. Please try again.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        searchResults = [];
        isSearching = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Search error: $e',
          ),
        ),
      );
    }
  }

  // ============================================================
  // SELECT SEARCH RESULT
  // ============================================================

  void selectSearchResult(
    dynamic result,
    String searchField,
  ) {
    final String displayName =
        result['display_name'] ??
            'Unknown location';

    final double latitude =
        double.parse(
      result['lat'].toString(),
    );

    final double longitude =
        double.parse(
      result['lon'].toString(),
    );

    final LatLng location = LatLng(
      latitude,
      longitude,
    );

    setState(() {
      searchResults = [];
      activeSearchField = '';

      if (searchField == 'origin') {
        selectedOrigin = location;
        originName = displayName;
        originController.text =
            displayName;
      } else {
        selectedDestination = location;
        destinationName = displayName;
        destinationController.text =
            displayName;
      }

      routePoints = [];
      routeDistance = null;
      routeDuration = null;
      selectedTravelMode = null;
    });

    mapController.move(
      location,
      14,
    );

    if (searchField == 'destination') {
      showTravelModeDialog();
    }
  }

  // ============================================================
  // USE CURRENT LOCATION
  // ============================================================

  Future<void> useCurrentLocation() async {
    if (currentLocation == null) {
      await getCurrentLocation();
    } else {
      setState(() {
        selectedOrigin = currentLocation;
        originName = 'My current location';
        originController.text =
            'My current location';

        routePoints = [];
        routeDistance = null;
        routeDuration = null;
      });

      mapController.move(
        currentLocation!,
        15,
      );
    }
  }

  // ============================================================
  // SWAP LOCATIONS
  // ============================================================

  void swapLocations() {
    if (selectedOrigin == null &&
        selectedDestination == null) {
      return;
    }

    setState(() {
      final LatLng? tempLocation =
          selectedOrigin;

      selectedOrigin =
          selectedDestination;

      selectedDestination =
          tempLocation;

      final String tempName =
          originController.text;

      originController.text =
          destinationController.text;

      destinationController.text =
          tempName;

      final String? tempOriginName =
          originName;

      originName = destinationName;

      destinationName =
          tempOriginName;

      routePoints = [];
      routeDistance = null;
      routeDuration = null;
      selectedTravelMode = null;
    });

    if (selectedOrigin != null) {
      mapController.move(
        selectedOrigin!,
        12,
      );
    }
  }

  // ============================================================
  // TRAVEL MODE DIALOG
  // ============================================================

  void showTravelModeDialog() {
    if (selectedDestination == null) {
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              22,
              12,
              22,
              30,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 45,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                const Text(
                  'How do you want to travel?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  destinationName ??
                      'Choose your destination',
                  maxLines: 2,
                  overflow:
                      TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 22),

                _travelModeTile(
                  icon: Icons.flight_rounded,
                  title: 'Air',
                  subtitle: 'Aeroplane',
                  onTap: () {
                    Navigator.pop(context);

                    setState(() {
                      selectedTravelMode =
                          'Aeroplane';
                    });

                    showUnsupportedModeMessage(
                      'Aeroplane',
                    );
                  },
                ),

                _travelModeTile(
                  icon:
                      Icons.directions_boat_rounded,
                  title: 'Water',
                  subtitle: 'Cruise / Ship',
                  onTap: () {
                    Navigator.pop(context);

                    setState(() {
                      selectedTravelMode =
                          'Cruise';
                    });

                    showUnsupportedModeMessage(
                      'Cruise',
                    );
                  },
                ),

                _travelModeTile(
                  icon:
                      Icons.directions_car_rounded,
                  title: 'Road',
                  subtitle:
                      'Car, Bus, Train or Bike',
                  onTap: () {
                    Navigator.pop(context);
                    showRoadModeDialog();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // TRAVEL MODE TILE
  // ============================================================

  Widget _travelModeTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin:
          const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: background,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: InkWell(
        borderRadius:
            BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 13,
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: lightBlue,
                  borderRadius:
                      BorderRadius.circular(15),
                ),
                child: Icon(
                  icon,
                  color: primaryBlue,
                  size: 28,
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:
                          const TextStyle(
                        fontSize: 17,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color:
                            Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        Colors.grey.shade200,
                  ),
                ),
                child: const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: primaryBlue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ROAD MODE
  // ============================================================

  void showRoadModeDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      shape:
          const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              22,
              12,
              22,
              30,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 45,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                const Text(
                  'Choose your travel mode',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  'Select how you will travel on the road',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 22),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    _roadModeButton(
                      Icons.directions_car_rounded,
                      'Car',
                      'Car',
                    ),
                    _roadModeButton(
                      Icons.directions_bus_rounded,
                      'Bus',
                      'Bus',
                    ),
                    _roadModeButton(
                      Icons.directions_bike_rounded,
                      'Bike',
                      'Bike',
                    ),
                    _roadModeButton(
                      Icons.train_rounded,
                      'Train',
                      'Train',
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // ROAD MODE BUTTON
  // ============================================================

  Widget _roadModeButton(
    IconData icon,
    String title,
    String mode,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);

        setState(() {
          selectedTravelMode = mode;
        });

        if (mode == 'Car' ||
            mode == 'Bike') {
          calculateRoadRoute();
        } else {
          showUnsupportedModeMessage(
            mode,
          );
        }
      },
      child: AnimatedContainer(
        duration:
            const Duration(milliseconds: 200),
        width: 72,
        padding:
            const EdgeInsets.symmetric(
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: background,
          borderRadius:
              BorderRadius.circular(18),
          border: Border.all(
            color: Colors.grey.shade200,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: lightBlue,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: primaryBlue,
                size: 25,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              title,
              style:
                  const TextStyle(
                fontWeight:
                    FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // CALCULATE ROUTE
  // ============================================================

  Future<void> calculateRoadRoute() async {
    if (selectedOrigin == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Please select a starting location.',
          ),
        ),
      );

      return;
    }

    if (selectedDestination == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Please select a destination.',
          ),
        ),
      );

      return;
    }

    setState(() {
      isRouting = true;
      routePoints = [];
      routeDistance = null;
      routeDuration = null;
    });

    try {
      final LatLng start =
          selectedOrigin!;

      final LatLng destination =
          selectedDestination!;

      final Uri url = Uri.parse(
        'https://router.project-osrm.org'
        '/route/v1/driving/'
        '${start.longitude},${start.latitude};'
        '${destination.longitude},${destination.latitude}'
        '?overview=full'
        '&geometries=geojson'
        '&steps=true'
        '&alternatives=true',
      );

      final response = await http
          .get(
            url,
            headers: {
              'User-Agent':
                  'Saarthi/1.0 (com.example.newproject)',
            },
          )
          .timeout(
            const Duration(seconds: 20),
          );

      if (response.statusCode != 200) {
        throw Exception(
          'Routing service is currently unavailable.',
        );
      }

      final Map<String, dynamic> data =
          jsonDecode(response.body);

      if (data['code'] != 'Ok') {
        throw Exception(
          'No road route exists between these locations.',
        );
      }

      final List<dynamic> routes =
          data['routes'] ?? [];

      if (routes.isEmpty) {
        throw Exception(
          'No road route was found.',
        );
      }

      Map<String, dynamic>
          shortestRoute =
          routes[0];

      for (final route in routes) {
        final double distance =
            (route['distance'] as num)
                .toDouble();

        final double shortestDistance =
            (shortestRoute['distance']
                    as num)
                .toDouble();

        if (distance <
            shortestDistance) {
          shortestRoute = route;
        }
      }

      final List<dynamic>
          coordinates =
          shortestRoute['geometry']
              ['coordinates'];

      final List<LatLng> points =
          coordinates
              .map(
                (coordinate) => LatLng(
                  (coordinate[1] as num)
                      .toDouble(),
                  (coordinate[0] as num)
                      .toDouble(),
                ),
              )
              .toList();

      if (!mounted) return;

      setState(() {
        routePoints = points;

        routeDistance =
            (shortestRoute['distance']
                    as num)
                .toDouble();

        routeDuration =
            (shortestRoute['duration']
                    as num)
                .toDouble();

        isRouting = false;
      });

      if (routePoints.isNotEmpty) {
        final bounds =
            LatLngBounds.fromPoints(
          routePoints,
        );

        mapController.fitCamera(
          CameraFit.bounds(
            bounds: bounds,
            padding:
                const EdgeInsets.all(75),
          ),
        );
      }
    } on TimeoutException {
      if (!mounted) return;

      setState(() {
        isRouting = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'The routing service took too long. Please try again.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isRouting = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst(
                  'Exception: ',
                  '',
                ),
          ),
        ),
      );
    }
  }

  // ============================================================
  // UNSUPPORTED MODE
  // ============================================================

  void showUnsupportedModeMessage(
    String mode,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(22),
          ),
          title: Text(
            '$mode selected',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Dedicated $mode routing will be connected to Saarthi in the multimodal routing stage.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child:
                  const Text('Got it'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // FORMAT DISTANCE
  // ============================================================

  String formatDistance(
    double meters,
  ) {
    if (meters < 1000) {
      return '${meters.round()} m';
    }

    return '${(meters / 1000).toStringAsFixed(1)} km';
  }

  // ============================================================
  // FORMAT DURATION
  // ============================================================

  String formatDuration(
    double seconds,
  ) {
    final int minutes =
        (seconds / 60).round();

    if (minutes < 60) {
      return '$minutes min';
    }

    final int hours =
        minutes ~/ 60;

    final int remainingMinutes =
        minutes % 60;

    if (remainingMinutes == 0) {
      return '$hours hr';
    }

    return '$hours hr '
        '$remainingMinutes min';
  }

  // ============================================================
  // LOCATION FIELD
  // ============================================================

  Widget _locationField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required Color iconColor,
    required String fieldType,
    required VoidCallback onCurrentLocation,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(17),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(0.10),
            blurRadius: 12,
            offset:
                const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,

        textInputAction:
            TextInputAction.search,

        onSubmitted: (value) {
          searchPlaces(
            value,
            fieldType,
          );
        },

        onChanged: (value) {
          if (value.isEmpty) {
            setState(() {
              searchResults = [];
            });
          }
        },

        decoration: InputDecoration(
          hintText: hint,

          hintStyle: TextStyle(
            color:
                Colors.grey.shade500,
            fontSize: 14,
          ),

          prefixIcon: Padding(
            padding:
                const EdgeInsets.all(12),
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: iconColor
                    .withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 17,
              ),
            ),
          ),

          suffixIcon: Row(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              if (isSearching &&
                  activeSearchField ==
                      fieldType)
                const Padding(
                  padding:
                      EdgeInsets.all(12),
                  child: SizedBox(
                    width: 19,
                    height: 19,
                    child:
                        CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                )
              else
                IconButton(
                  tooltip: 'Search',
                  icon:
                      const Icon(
                    Icons.search_rounded,
                    color: primaryBlue,
                    size: 22,
                  ),
                  onPressed: () {
                    searchPlaces(
                      controller.text,
                      fieldType,
                    );
                  },
                ),

              if (fieldType ==
                  'origin')
                IconButton(
                  tooltip:
                      'Use current location',
                  icon:
                      const Icon(
                    Icons.my_location_rounded,
                    color: green,
                    size: 21,
                  ),
                  onPressed:
                      onCurrentLocation,
                ),
            ],
          ),

          filled: true,
          fillColor: Colors.white,

          border:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(
              17,
            ),
            borderSide:
                BorderSide.none,
          ),

          enabledBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(
              17,
            ),
            borderSide:
                BorderSide.none,
          ),

          focusedBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(
              17,
            ),
            borderSide:
                const BorderSide(
              color: primaryBlue,
              width: 1.3,
            ),
          ),

          contentPadding:
              const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 15,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // INITIAL STATE
  // ============================================================

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      getCurrentLocation();
    });
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    originController.dispose();
    destinationController.dispose();

    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor: background,

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        titleSpacing: 0,

        title: const Text(
          'Saarthi Map',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.2,
          ),
        ),

        actions: [
          IconButton(
            tooltip:
                'My current location',
            icon: const Icon(
              Icons.my_location_rounded,
            ),
            onPressed:
                useCurrentLocation,
          ),

          const SizedBox(width: 6),
        ],
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: Stack(
        children: [
          // ======================================================
          // MAP
          // ======================================================

          FlutterMap(
            mapController:
                mapController,

            options: MapOptions(
              initialCenter:
                  initialLocation,
              initialZoom: 12,
              minZoom: 3,
              maxZoom: 18,
            ),

            children: [
              // --------------------------------------------------
              // MAP TILES
              // --------------------------------------------------

              TileLayer(
                urlTemplate:
                    'https://tile.openstreetmap.org/'
                    '{z}/{x}/{y}.png',

                userAgentPackageName:
                    'com.example.newproject',
              ),

              // --------------------------------------------------
              // ROUTE
              // --------------------------------------------------

              if (routePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: routePoints,
                      strokeWidth: 8,
                      color: primaryBlue,
                    ),
                  ],
                ),

              // --------------------------------------------------
              // MARKERS
              // --------------------------------------------------

              MarkerLayer(
                markers: [
                  if (selectedOrigin != null)
                    Marker(
                      point:
                          selectedOrigin!,
                      width: 52,
                      height: 52,
                      child: Container(
                        decoration:
                            BoxDecoration(
                          color: Colors.white,
                          shape:
                              BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors
                                  .black
                                  .withOpacity(
                                      0.20),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.trip_origin_rounded,
                          color: green,
                          size: 30,
                        ),
                      ),
                    ),

                  if (selectedDestination !=
                      null)
                    Marker(
                      point:
                          selectedDestination!,
                      width: 58,
                      height: 58,
                      child: Container(
                        decoration:
                            BoxDecoration(
                          color: Colors.white,
                          shape:
                              BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors
                                  .black
                                  .withOpacity(
                                      0.22),
                              blurRadius: 9,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.location_on_rounded,
                          color: red,
                          size: 38,
                        ),
                      ),
                    ),
                ],
              ),

              // --------------------------------------------------
              // ATTRIBUTION
              // --------------------------------------------------

              RichAttributionWidget(
                attributions: [
                  TextSourceAttribution(
                    'OpenStreetMap contributors',
                  ),
                ],
              ),
            ],
          ),

          // ======================================================
          // TOP JOURNEY PANEL
          // ======================================================

          Positioned(
            top: 12,
            left: 12,
            right: 12,
            child: Column(
              children: [
                // ------------------------------------------------
                // FROM
                // ------------------------------------------------

                _locationField(
                  controller:
                      originController,
                  hint:
                      'Where are you starting from?',
                  icon:
                      Icons.trip_origin_rounded,
                  iconColor: green,
                  fieldType: 'origin',
                  onCurrentLocation:
                      useCurrentLocation,
                ),

                const SizedBox(
                  height: 7,
                ),

                // ------------------------------------------------
                // SWAP BUTTON
                // ------------------------------------------------

                Align(
                  alignment:
                      Alignment.centerRight,
                  child: Transform.translate(
                    offset:
                        const Offset(
                      -16,
                      0,
                    ),
                    child: GestureDetector(
                      onTap:
                          swapLocations,
                      child:
                          Container(
                        width: 38,
                        height: 38,
                        decoration:
                            BoxDecoration(
                          color:
                              Colors.white,
                          shape:
                              BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors
                                  .black
                                  .withOpacity(
                                      0.13),
                              blurRadius: 8,
                              offset:
                                  const Offset(
                                0,
                                3,
                              ),
                            ),
                          ],
                        ),
                        child:
                            const Icon(
                          Icons
                              .swap_vert_rounded,
                          color:
                              primaryBlue,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 2,
                ),

                // ------------------------------------------------
                // TO
                // ------------------------------------------------

                _locationField(
                  controller:
                      destinationController,
                  hint:
                      'Where do you want to go?',
                  icon:
                      Icons.location_on_rounded,
                  iconColor: red,
                  fieldType:
                      'destination',
                  onCurrentLocation:
                      () {},
                ),
              ],
            ),
          ),

          // ======================================================
          // SEARCH RESULTS
          // ======================================================

          if (searchResults.isNotEmpty)
            Positioned(
              top: 139,
              left: 12,
              right: 12,
              child: Material(
                elevation: 8,
                borderRadius:
                    BorderRadius.circular(
                  18,
                ),
                child: Container(
                  constraints:
                      const BoxConstraints(
                    maxHeight: 300,
                  ),
                  decoration:
                      BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(
                      18,
                    ),
                  ),
                  child:
                      ListView.separated(
                    shrinkWrap: true,
                    padding:
                        const EdgeInsets
                            .symmetric(
                      vertical: 6,
                    ),
                    itemCount:
                        searchResults.length,
                    separatorBuilder:
                        (context, index) {
                      return Divider(
                        height: 1,
                        color: Colors
                            .grey.shade100,
                      );
                    },
                    itemBuilder:
                        (context, index) {
                      final result =
                          searchResults[
                              index];

                      final String
                          displayName =
                          result[
                                  'display_name'] ??
                              'Unknown location';

                      return ListTile(
                        contentPadding:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 15,
                          vertical: 3,
                        ),

                        leading:
                            Container(
                          width: 40,
                          height: 40,
                          decoration:
                              BoxDecoration(
                            color:
                                lightBlue,
                            shape:
                                BoxShape
                                    .circle,
                          ),
                          child:
                              const Icon(
                            Icons
                                .location_on_rounded,
                            color:
                                primaryBlue,
                            size: 22,
                          ),
                        ),

                        title:
                            Text(
                          displayName,
                          maxLines: 2,
                          overflow:
                              TextOverflow
                                  .ellipsis,
                          style:
                              const TextStyle(
                            fontSize: 14,
                            fontWeight:
                                FontWeight
                                    .w500,
                          ),
                        ),

                        trailing:
                            const Icon(
                          Icons
                              .arrow_forward_ios,
                          size: 14,
                          color:
                              Colors.grey,
                        ),

                        onTap: () {
                          selectSearchResult(
                            result,
                            activeSearchField,
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),

          // ======================================================
          // ROUTE CARD
          // ======================================================

          if (routePoints.isNotEmpty &&
              routeDistance != null &&
              routeDuration != null)
            Positioned(
              left: 12,
              right: 12,
              bottom: 18,
              child: AnimatedContainer(
                duration:
                    const Duration(
                  milliseconds: 300,
                ),
                padding:
                    const EdgeInsets.all(
                  16,
                ),
                decoration:
                    BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(
                    23,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withOpacity(
                        0.18,
                      ),
                      blurRadius: 18,
                      offset:
                          const Offset(
                        0,
                        6,
                      ),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration:
                              BoxDecoration(
                            color:
                                lightBlue,
                            borderRadius:
                                BorderRadius
                                    .circular(
                              16,
                            ),
                          ),
                          child: Icon(
                            selectedTravelMode ==
                                    'Bike'
                                ? Icons
                                    .directions_bike_rounded
                                : Icons
                                    .directions_car_rounded,
                            color:
                                primaryBlue,
                            size: 28,
                          ),
                        ),

                        const SizedBox(
                          width: 13,
                        ),

                        Expanded(
                          child:
                              Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              Text(
                                selectedTravelMode ??
                                    'Route',
                                style:
                                    const TextStyle(
                                  fontSize:
                                      17,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),

                              const SizedBox(
                                height: 4,
                              ),

                              Text(
                                destinationName ??
                                    'Your destination',
                                maxLines:
                                    1,
                                overflow:
                                    TextOverflow
                                        .ellipsis,
                                style:
                                    TextStyle(
                                  fontSize:
                                      12,
                                  color: Colors
                                      .grey
                                      .shade600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        IconButton(
                          icon:
                              const Icon(
                            Icons.close_rounded,
                          ),
                          color:
                              Colors.grey,
                          onPressed: () {
                            setState(() {
                              routePoints =
                                  [];

                              routeDistance =
                                  null;

                              routeDuration =
                                  null;

                              selectedDestination =
                                  null;

                              destinationName =
                                  null;

                              destinationController
                                  .clear();

                              selectedTravelMode =
                                  null;
                            });
                          },
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 14,
                    ),

                    Row(
                      children: [
                        Expanded(
                          child:
                              _routeStat(
                            Icons
                                .straighten_rounded,
                            formatDistance(
                              routeDistance!,
                            ),
                            'Distance',
                          ),
                        ),

                        Container(
                          width: 1,
                          height: 38,
                          color: Colors
                              .grey
                              .shade200,
                        ),

                        Expanded(
                          child:
                              _routeStat(
                            Icons
                                .schedule_rounded,
                            formatDuration(
                              routeDuration!,
                            ),
                            'Estimated time',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          // ======================================================
          // ROUTING LOADER
          // ======================================================

          if (isRouting)
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  color: Colors.black
                      .withOpacity(
                    0.12,
                  ),
                  child: Center(
                    child: Container(
                      padding:
                          const EdgeInsets
                              .symmetric(
                        horizontal: 24,
                        vertical: 20,
                      ),
                      decoration:
                          BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius
                                .circular(
                          20,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors
                                .black
                                .withOpacity(
                              0.15,
                            ),
                            blurRadius:
                                15,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize:
                            MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 32,
                            height: 32,
                            child:
                                CircularProgressIndicator(
                              strokeWidth: 3,
                              color:
                                  primaryBlue,
                            ),
                          ),

                          const SizedBox(
                            height: 13,
                          ),

                          const Text(
                            'Finding the best route...',
                            style:
                                TextStyle(
                              fontWeight:
                                  FontWeight
                                      .bold,
                              fontSize: 15,
                            ),
                          ),

                          const SizedBox(
                            height: 4,
                          ),

                          Text(
                            'Please wait',
                            style:
                                TextStyle(
                              fontSize: 12,
                              color: Colors
                                  .grey
                                  .shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // ======================================================
          // MAP CONTROLS
          // ======================================================

          Positioned(
            right: 14,
            bottom:
                routePoints.isNotEmpty
                    ? 185
                    : 28,
            child: Column(
              children: [
                // ZOOM IN
                _mapControl(
                  icon: Icons.add_rounded,
                  onTap: () {
                    final double
                        currentZoom =
                        mapController
                            .camera.zoom;

                    if (currentZoom <
                        18) {
                      mapController
                          .move(
                        mapController
                            .camera.center,
                        currentZoom + 1,
                      );
                    }
                  },
                ),

                const SizedBox(
                  height: 8,
                ),

                // ZOOM OUT
                _mapControl(
                  icon:
                      Icons.remove_rounded,
                  onTap: () {
                    final double
                        currentZoom =
                        mapController
                            .camera.zoom;

                    if (currentZoom >
                        3) {
                      mapController
                          .move(
                        mapController
                            .camera.center,
                        currentZoom - 1,
                      );
                    }
                  },
                ),

                const SizedBox(
                  height: 8,
                ),

                // MY LOCATION
                _mapControl(
                  icon: Icons
                      .my_location_rounded,
                  active: true,
                  onTap:
                      useCurrentLocation,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ROUTE STAT
  // ============================================================

  Widget _routeStat(
    IconData icon,
    String value,
    String label,
  ) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: primaryBlue,
          size: 21,
        ),

        const SizedBox(width: 8),

        Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color:
                    Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // MAP CONTROL
  // ============================================================

  Widget _mapControl({
    required IconData icon,
    required VoidCallback onTap,
    bool active = false,
  }) {
    return Material(
      color: Colors.white,
      elevation: 5,
      shadowColor:
          Colors.black.withOpacity(0.18),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder:
            const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(
            icon,
            color: active
                ? primaryBlue
                : Colors.grey.shade700,
            size: 23,
          ),
        ),
      ),
    );
  }
}