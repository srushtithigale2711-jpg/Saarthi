import 'package:flutter/material.dart';

import '../data/saved_places.dart';

class SavedScreen extends StatefulWidget {
  final VoidCallback? onExploreDestinations;

  const SavedScreen({
    super.key,
    this.onExploreDestinations,
  });

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  // ==========================================================
  // REMOVE SAVED PLACE
  // ==========================================================

  void removePlace(String name) {
    SavedPlaces.removePlace(name);
  }

  // ==========================================================
  // CLEAR ALL SAVED PLACES
  // ==========================================================

  void clearAll() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Clear Saved Places?',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Color(0xFF123B65),
            ),
          ),
          content: const Text(
            'Are you sure you want to remove all saved places?',
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF607D8B),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'CANCEL',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF607D8B),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                SavedPlaces.clearAll();

                Navigator.pop(dialogContext);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1565C0),
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'CLEAR',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: SavedPlaces.version,
      builder: (context, _, child) {
        final places = SavedPlaces.places;

        return Scaffold(
          backgroundColor: const Color(0xFFF5F9FE),

          // ========================================================
          // APP BAR
          // ========================================================

          appBar: AppBar(
            backgroundColor: const Color(0xFF1565C0),
            foregroundColor: Colors.white,
            elevation: 0,

            title: const Text(
              'Saved Places',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            actions: [
              if (places.isNotEmpty)
                IconButton(
                  onPressed: clearAll,
                  icon: const Icon(
                    Icons.delete_outline,
                    size: 25,
                  ),
                  tooltip: 'Clear all',
                ),
            ],
          ),

          // ========================================================
          // BODY
          // ========================================================

          body: places.isEmpty
              ? _buildEmptyState()
              : _buildSavedPlaces(places),
        );
      },
    );
  }

  // ==========================================================
  // EMPTY STATE
  // ==========================================================

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 28,
          vertical: 30,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ==================================================
            // EMPTY HEART ICON
            // ==================================================

            Container(
              width: 105,
              height: 105,
              decoration: const BoxDecoration(
                color: Color(0xFFE3F2FD),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border,
                size: 55,
                color: Color(0xFF1565C0),
              ),
            ),

            const SizedBox(height: 25),

            // ==================================================
            // TITLE
            // ==================================================

            const Text(
              'No Saved Places',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Color(0xFF123B65),
              ),
            ),

            const SizedBox(height: 10),

            // ==================================================
            // DESCRIPTION
            // ==================================================

            const Text(
              'You haven\'t saved any destinations yet.\n'
              'Explore destinations and save your favourites here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                height: 1.5,
                fontWeight: FontWeight.w500,
                color: Color(0xFF607D8B),
              ),
            ),

            const SizedBox(height: 30),

            // ==================================================
            // EXPLORE DESTINATIONS BUTTON
            // ==================================================

            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  widget.onExploreDestinations?.call();
                },

                icon: const Icon(
                  Icons.explore,
                  size: 22,
                ),

                label: const Text(
                  'Explore Destinations',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  foregroundColor: Colors.white,
                  elevation: 3,

                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                  ),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // SAVED PLACES LIST
  // ==========================================================

  Widget _buildSavedPlaces(
    List<Map<String, dynamic>> places,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(18),

      itemCount: places.length,

      itemBuilder: (context, index) {
        final place = places[index];

        final String name =
            place['name'] as String? ?? 'Unknown Place';

        final String subtitle =
            place['subtitle'] as String? ?? '';

        final IconData icon =
            place['icon'] as IconData? ?? Icons.location_on;

        return Container(
          margin: const EdgeInsets.only(
            bottom: 14,
          ),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),

            border: Border.all(
              color: const Color(0xFFD7E1EA),
            ),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),

          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 9,
            ),

            // ==================================================
            // PLACE ICON
            // ==================================================

            leading: Container(
              width: 50,
              height: 50,

              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(13),
              ),

              child: Icon(
                icon,
                color: const Color(0xFF1565C0),
                size: 25,
              ),
            ),

            // ==================================================
            // PLACE NAME
            // ==================================================

            title: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,

              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF123B65),
              ),
            ),

            // ==================================================
            // PLACE SUBTITLE
            // ==================================================

            subtitle: Padding(
              padding: const EdgeInsets.only(
                top: 4,
              ),
              child: Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,

                style: const TextStyle(
                  fontSize: 13,
                  height: 1.3,
                  color: Color(0xFF607D8B),
                ),
              ),
            ),

            // ==================================================
            // REMOVE BUTTON
            // ==================================================

            trailing: IconButton(
              onPressed: () {
                removePlace(name);
              },

              icon: const Icon(
                Icons.favorite,
                color: Color(0xFFE53935),
                size: 25,
              ),

              tooltip: 'Remove from saved',
            ),
          ),
        );
      },
    );
  }
}