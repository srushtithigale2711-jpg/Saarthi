import 'package:flutter/material.dart';

import 'trip_planner_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedPlace = 'Goa';

  final List<String> places = [
    'Goa',
    'Mumbai',
    'Jaipur',
    'Kerala',
    'Manali',
    'Delhi',
  ];

  void selectPlace(String? value) {
    if (value != null) {
      setState(() {
        selectedPlace = value;
      });
    }
  }

  // ==========================================================
  // FEATURE ACTION
  // ==========================================================

  void openFeature(String title, String description, IconData icon) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: const Color(0xFFE3F2FD),
                child: Icon(icon, size: 38, color: const Color(0xFF1565C0)),
              ),

              const SizedBox(height: 15),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF123B65),
                ),
              ),

              const SizedBox(height: 10),

              Text(
                '$description\n\nSelected destination: $selectedPlace',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15, color: Colors.grey),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1565C0),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Continue'),
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  // ==========================================================
  // HOME PAGE UI
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FE),

      // --------------------------------------------------------
      // APP BAR
      // --------------------------------------------------------
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        elevation: 0,

        title: const Row(
          children: [
            Icon(Icons.travel_explore, size: 27),
            SizedBox(width: 10),
            Text(
              'Saarthi',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),

        actions: [
          IconButton(
            onPressed: () {
              showMessage(context, 'No new notifications.');
            },
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),

      // --------------------------------------------------------
      // HOME BODY
      // --------------------------------------------------------
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hello, Traveller! 👋',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF123B65),
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              'Plan your perfect journey with Saarthi.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 20),

            // =================================================
            // DESTINATION SELECTION
            // =================================================
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Where are you going?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedPlace,
                        isExpanded: true,
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Color(0xFF1565C0),
                        ),
                        items: places.map((place) {
                          return DropdownMenuItem(
                            value: place,
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Color(0xFF1976D2),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(place),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: selectPlace,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Travel Services',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Color(0xFF123B65),
              ),
            ),

            const SizedBox(height: 15),

            // =================================================
            // SERVICE GRID
            // =================================================
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.35,
              children: [
                serviceCard(
                  icon: Icons.hotel,
                  title: 'Accommodations',
                  subtitle: 'Hotels & stays',
                  onTap: () {
                    openFeature(
                      'Accommodations',
                      'Find hotels, resorts and comfortable stays.',
                      Icons.hotel,
                    );
                  },
                ),

                serviceCard(
                  icon: Icons.directions_car,
                  title: 'Travel',
                  subtitle: 'Transport options',
                  onTap: () {
                    openFeature(
                      'Travel',
                      'Explore transport and travel options.',
                      Icons.directions_car,
                    );
                  },
                ),

                // =================================================
                // PACKAGES → TRIP PLANNER
                // =================================================
                serviceCard(
                  icon: Icons.card_travel,
                  title: 'Packages',
                  subtitle: 'Plan your trip',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TripPlannerScreen(),
                      ),
                    );
                  },
                ),

                serviceCard(
                  icon: Icons.restaurant,
                  title: 'Food',
                  subtitle: 'Local recommendations',
                  onTap: () {
                    openFeature(
                      'Food Recommendations',
                      'Discover recommended local food and restaurants.',
                      Icons.restaurant,
                    );
                  },
                ),

                serviceCard(
                  icon: Icons.shield,
                  title: 'Travel Insurance',
                  subtitle: 'Stay protected',
                  onTap: () {
                    openFeature(
                      'Travel Insurance',
                      'Explore travel protection and insurance options.',
                      Icons.shield,
                    );
                  },
                ),

                serviceCard(
                  icon: Icons.place,
                  title: 'Tourist Attractions',
                  subtitle: 'Places to visit',
                  onTap: () {
                    openFeature(
                      'Tourist Attractions',
                      'Discover popular attractions and hidden gems.',
                      Icons.place,
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 25),

            // =================================================
            // SAFETY SECTION
            // =================================================
            const Text(
              'Safety & Emergency',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Color(0xFF123B65),
              ),
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: emergencyCard(
                    icon: Icons.phone,
                    title: 'Contacts',
                    onTap: () {
                      openFeature(
                        'Emergency Contacts',
                        'Access important emergency and local contacts.',
                        Icons.phone,
                      );
                    },
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: emergencyCard(
                    icon: Icons.warning_amber_rounded,
                    title: 'Emergency',
                    onTap: () {
                      openFeature(
                        'Emergency Assistance',
                        'Quick access to emergency assistance.',
                        Icons.warning_amber_rounded,
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // =================================================
            // GPS BUTTON
            // =================================================
            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton.icon(
                onPressed: () {
                  openFeature(
                    'GPS / Google Maps',
                    'Use your location to navigate and explore nearby places.',
                    Icons.map,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D47A1),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.my_location),
                label: const Text(
                  'GPS / GOOGLE MAPS',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 90),
          ],
        ),
      ),

      // ========================================================
      // AI RECOMMENDATION BUTTON
      // ========================================================
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          openFeature(
            'Saarthi AI',
            'Get intelligent travel recommendations based on your destination, interests and preferences.',
            Icons.auto_awesome,
          );
        },
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.auto_awesome),
        label: const Text(
          'AI Recommendations',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // ==========================================================
  // SERVICE CARD
  // ==========================================================

  Widget serviceCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: const Color(0xFF1565C0), size: 28),
            ),

            const SizedBox(height: 8),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF123B65),
              ),
            ),

            const SizedBox(height: 3),

            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // EMERGENCY CARD
  // ==========================================================

  Widget emergencyCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF1565C0), size: 30),

            const SizedBox(height: 5),

            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF123B65),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// MESSAGE HELPER
// ============================================================

void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
  );
}
