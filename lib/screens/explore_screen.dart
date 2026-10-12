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
        'image': 'assets/images/goa.jpg',
      },
      {
        'name': 'Jaipur',
        'subtitle': 'Forts • Culture • Heritage',
        'icon': Icons.account_balance,
        'image': 'assets/images/jaipur.jpg',
      },
      {
        'name': 'Kerala',
        'subtitle': 'Backwaters • Nature • Wellness',
        'icon': Icons.nature,
        'image': 'assets/images/kerala.jpg',
      },
      {
        'name': 'Manali',
        'subtitle': 'Mountains • Snow • Adventure',
        'icon': Icons.terrain,
        'image': 'assets/images/manali.jpg',
      },
      {
        'name': 'Mumbai',
        'subtitle': 'City • Food • Entertainment',
        'icon': Icons.location_city,
        'image': 'assets/images/mumbai.jpg',
      },
      {
        'name': 'Delhi',
        'subtitle': 'History • Culture • Food',
        'icon': Icons.museum,
        'image': 'assets/images/delhi.jpg',
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

            // Destination cards
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 14,
                childAspectRatio: 0.82,
              ),
              itemCount: destinations.length,
              itemBuilder: (context, index) {
                final destination = destinations[index];

                return InkWell(
                  borderRadius: BorderRadius.circular(18),

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
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Destination image
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(18),
                            topRight: Radius.circular(18),
                          ),
                          child: Image.asset(
                            destination['image'],
                            width: double.infinity,
                            height: 115,
                            fit: BoxFit.cover,

                            // Fallback if image has a problem
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 115,
                                color: const Color(0xFFE3F2FD),
                                child: Center(
                                  child: Icon(
                                    destination['icon'],
                                    size: 38,
                                    color: const Color(0xFF1565C0),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        // Card information
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                              12,
                              10,
                              12,
                              10,
                            ),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  destination['name'],
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF123B65),
                                  ),
                                ),

                                const SizedBox(height: 5),

                                Expanded(
                                  child: Text(
                                    destination['subtitle'],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                      height: 1.3,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 5),

                                // Save button
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints:
                                          const BoxConstraints(),
                                      icon: const Icon(
                                        Icons.bookmark_border,
                                        size: 22,
                                        color: Color(0xFF1565C0),
                                      ),
                                      onPressed: () {
                                        SavedPlaces.addPlace(
                                          name: destination['name'],
                                          subtitle:
                                              destination['subtitle'],
                                          icon: destination['icon'],
                                        );

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              '${destination['name']} saved successfully ❤️',
                                            ),
                                            behavior:
                                                SnackBarBehavior.floating,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Get Recommendations',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
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