import 'package:flutter/material.dart';

import '../services/destination_service.dart';

class DestinationTestScreen extends StatefulWidget {
  const DestinationTestScreen({super.key});

  @override
  State<DestinationTestScreen> createState() =>
      _DestinationTestScreenState();
}

class _DestinationTestScreenState
    extends State<DestinationTestScreen> {
  bool isLoading = false;

  String statusMessage = 'Press the button to test Goa attractions.';

  List<Map<String, dynamic>> attractions = [];

  Future<void> testGoaAttractions() async {
    setState(() {
      isLoading = true;
      statusMessage = 'Fetching real attractions from OpenStreetMap...';
      attractions = [];
    });

    try {
      final results =
          await DestinationService.fetchAttractions('Goa');

      setState(() {
        attractions = results;
        statusMessage =
            'Found ${results.length} attractions in Goa.';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        statusMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SAARTHI Data Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Real Destination Data Test',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'This test fetches real tourism attractions '
              'from OpenStreetMap for Goa.',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed:
                    isLoading ? null : testGoaAttractions,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                        'Fetch Goa Attractions',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              statusMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: ListView.builder(
                itemCount: attractions.length,
                itemBuilder: (context, index) {
                  final attraction = attractions[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.location_on),
                      ),
                      title: Text(
                        attraction['name']?.toString() ??
                            'Unknown place',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'Category: '
                        '${attraction['category'] ?? 'Attraction'}\n'
                        'Latitude: '
                        '${attraction['latitude'] ?? 'N/A'}\n'
                        'Longitude: '
                        '${attraction['longitude'] ?? 'N/A'}',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}