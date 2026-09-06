import 'package:flutter/material.dart';

import '../data/saved_places.dart';
import 'trip_planner_screen.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  // ==========================================================
  // REMOVE SAVED PLACE
  // ==========================================================

  void removePlace(int index) {
    final removedPlace = SavedPlaces.places[index]['name'];

    setState(() {
      SavedPlaces.removePlace(removedPlace);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$removedPlace removed from saved places.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ==========================================================
  // CLEAR ALL SAVED PLACES
  // ==========================================================

  void clearAll() {
    setState(() {
      SavedPlaces.places.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All saved places have been removed.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ==========================================================
  // BUILD UI
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FE),

      // ========================================================
      // APP BAR
      // ========================================================
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        elevation: 0,

        title: const Row(
          children: [
            Icon(Icons.favorite, size: 25),
            SizedBox(width: 10),
            Text(
              'Saved',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),

        actions: [
          if (SavedPlaces.places.isNotEmpty)
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Clear Saved Places?'),
                      content: const Text(
                        'Are you sure you want to remove all saved destinations?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            clearAll();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1565C0),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Clear All'),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.delete_sweep_outlined),
            ),
        ],
      ),

      // ========================================================
      // BODY
      // ========================================================
      body: SavedPlaces.places.isEmpty
          ? _buildEmptyState()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Saved Places ❤️',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF123B65),
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Keep track of the destinations you want to visit.',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),

                  const SizedBox(height: 22),

                  // ==================================================
                  // SAVED PLACE CARDS
                  // ==================================================
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),

                    itemCount: SavedPlaces.places.length,

                    itemBuilder: (context, index) {
                      final place = SavedPlaces.places[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
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

                        child: Row(
                          children: [
                            // Destination Icon
                            Container(
                              width: 60,
                              height: 60,

                              decoration: BoxDecoration(
                                color: const Color(0xFFE3F2FD),
                                borderRadius: BorderRadius.circular(16),
                              ),

                              child: Icon(
                                place['icon'],
                                color: const Color(0xFF1565C0),
                                size: 32,
                              ),
                            ),

                            const SizedBox(width: 15),

                            // Destination Information
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    place['name'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF123B65),
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  Text(
                                    place['subtitle'],
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  const Row(
                                    children: [
                                      Icon(
                                        Icons.favorite,
                                        size: 15,
                                        color: Color(0xFF1565C0),
                                      ),

                                      SizedBox(width: 5),

                                      Text(
                                        'Saved destination',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF1565C0),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Delete Button
                            IconButton(
                              onPressed: () {
                                removePlace(index);
                              },
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 15),

                  // ==================================================
                  // AI RECOMMENDATION CARD
                  // ==================================================
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),

                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
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
                              size: 27,
                            ),

                            SizedBox(width: 10),

                            Text(
                              'Plan Your Journey',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          'Use your saved destinations to create a personalized travel plan with Saarthi.',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),

                        const SizedBox(height: 15),

                        // ==================================================
                        // STEP 12.2 - OPEN TRIP PLANNER
                        // ==================================================
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TripPlannerScreen(),
                              ),
                            );
                          },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF1565C0),
                          ),

                          child: const Text('Plan My Trip'),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),
                ],
              ),
            ),
    );
  }

  // ==========================================================
  // EMPTY STATE
  // ==========================================================

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,

              decoration: const BoxDecoration(
                color: Color(0xFFE3F2FD),
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.favorite_border,
                size: 50,
                color: Color(0xFF1565C0),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'No Saved Places',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF123B65),
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Explore destinations and save the places you would like to visit.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 25),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1565C0),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),

              icon: const Icon(Icons.explore),

              label: const Text('Explore Destinations'),
            ),
          ],
        ),
      ),
    );
  }
}
