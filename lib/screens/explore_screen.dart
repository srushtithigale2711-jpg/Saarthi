import 'package:flutter/material.dart';
import '../data/saved_places.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> destinations = [
      {
        'name': 'Goa',
        'subtitle': 'Beaches • Nightlife • Adventure',
        'icon': Icons.beach_access,
      },
      {
        'name': 'Jaipur',
        'subtitle': 'Forts • Culture • Heritage',
        'icon': Icons.account_balance,
      },
      {
        'name': 'Kerala',
        'subtitle': 'Backwaters • Nature • Wellness',
        'icon': Icons.nature,
      },
      {
        'name': 'Manali',
        'subtitle': 'Mountains • Snow • Adventure',
        'icon': Icons.terrain,
      },
      {
        'name': 'Mumbai',
        'subtitle': 'City • Food • Entertainment',
        'icon': Icons.location_city,
      },
      {
        'name': 'Delhi',
        'subtitle': 'History • Culture • Food',
        'icon': Icons.museum,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FE),

      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Explore',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Explore India 🇮🇳',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
                color: Color(0xFF123B65),
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Discover destinations, experiences and hidden gems.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 22),

            // Search bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search destinations...',
                prefixIcon: const Icon(
                  Icons.search,
                  color: Color(0xFF1565C0),
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Popular Destinations',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Color(0xFF123B65),
              ),
            ),

            const SizedBox(height: 15),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.95,
              ),
              itemCount: destinations.length,
              itemBuilder: (context, index) {
                final destination = destinations[index];

                return InkWell(
                  borderRadius: BorderRadius.circular(18),

                  // STEP 10.2:
                  // Save destination when the card is tapped.
                  onTap: () {
                    SavedPlaces.addPlace(
                      name: destination['name'],
                      subtitle: destination['subtitle'],
                      icon: destination['icon'],
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${destination['name']} saved successfully ❤️',
                        ),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },

                  child: Container(
                    padding: const EdgeInsets.all(16),
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
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3F2FD),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            destination['icon'],
                            size: 32,
                            color: const Color(0xFF1565C0),
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          destination['name'],
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF123B65),
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          destination['subtitle'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 25),

            // AI recommendation section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF1565C0),
                    Color(0xFF42A5F5),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        color: Colors.white,
                        size: 28,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Saarthi AI',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Get personalized destination recommendations based on your interests.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 15),

                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'AI recommendations will be available soon.',
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF1565C0),
                    ),
                    child: const Text(
                      'Get Recommendations',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}