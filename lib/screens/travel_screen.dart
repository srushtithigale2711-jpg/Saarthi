import 'package:flutter/material.dart';

class TravelScreen extends StatelessWidget {
  const TravelScreen({super.key});

  static const Color primaryBlue = Color(0xFF1565C0);
  static const Color deepBlue = Color(0xFF0D47A1);
  static const Color darkBlue = Color(0xFF123B65);
  static const Color pageBackground = Color(0xFFF1F7FD);

  static const List<Map<String, dynamic>> options = [
    {'title': 'Road Travel', 'subtitle': 'Cars, taxis and buses', 'icon': Icons.directions_car_rounded, 'description': 'Explore road transport for flexible journeys, local sightseeing and intercity travel.', 'color': Color(0xFF1565C0)},
    {'title': 'Train Travel', 'subtitle': 'Rail journeys across India', 'icon': Icons.train_rounded, 'description': 'Consider train travel for comfortable journeys between cities and popular destinations.', 'color': Color(0xFF00897B)},
    {'title': 'Air Travel', 'subtitle': 'Flights for longer journeys', 'icon': Icons.flight_rounded, 'description': 'Explore flight options when you want to cover long distances in less time.', 'color': Color(0xFF5E35B1)},
    {'title': 'Water Travel', 'subtitle': 'Ferries and boat rides', 'icon': Icons.directions_boat_rounded, 'description': 'Discover ferries, cruises and boat rides where they are available at your destination.', 'color': Color(0xFF0086C3)},
    {'title': 'Local Transport', 'subtitle': 'Metro, auto and local buses', 'icon': Icons.directions_transit_rounded, 'description': 'Plan how to move around after reaching your destination using local transport.', 'color': Color(0xFFE07824)},
    {'title': 'Self-Drive', 'subtitle': 'Freedom to explore at your pace', 'icon': Icons.route_rounded, 'description': 'A self-drive option may suit road trips with multiple stops and flexible schedules.', 'color': Color(0xFF43864A)},
  ];

  void _showDetails(BuildContext context, Map<String, dynamic> option) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => Container(
        padding: const EdgeInsets.fromLTRB(22, 12, 22, 24),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(26))),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 42, height: 4, decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(4)))),
              const SizedBox(height: 22),
              CircleAvatar(radius: 30, backgroundColor: (option['color'] as Color).withValues(alpha: 0.12), child: Icon(option['icon'] as IconData, color: option['color'] as Color, size: 30)),
              const SizedBox(height: 16),
              Text(option['title'] as String, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: darkBlue)),
              const SizedBox(height: 8),
              Text(option['description'] as String, style: const TextStyle(fontSize: 15, height: 1.55, color: Colors.black87)),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(sheetContext);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Live transport search and booking are not connected yet.')));
                  },
                  icon: const Icon(Icons.info_outline_rounded),
                  label: const Text('Explore option'),
                  style: ElevatedButton.styleFrom(backgroundColor: primaryBlue, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBackground,
      appBar: AppBar(title: const Text('Travel', style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: primaryBlue, foregroundColor: Colors.white, elevation: 0),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [deepBlue, primaryBlue, Color(0xFF42A5F5)], begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(24)),
            child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(Icons.explore_rounded, color: Colors.white, size: 38),
              SizedBox(height: 15),
              Text('Choose how you travel', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Find a travel style that fits your destination, time and budget.', style: TextStyle(color: Colors.white, height: 1.45, fontSize: 14)),
            ]),
          ),
          const SizedBox(height: 23),
          const Text('Travel options', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: darkBlue)),
          const SizedBox(height: 12),
          ...options.map((option) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => _showDetails(context, option),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(children: [
                    Container(width: 56, height: 56, decoration: BoxDecoration(color: (option['color'] as Color).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(16)), child: Icon(option['icon'] as IconData, color: option['color'] as Color, size: 29)),
                    const SizedBox(width: 14),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(option['title'] as String, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: darkBlue)), const SizedBox(height: 5), Text(option['subtitle'] as String, style: TextStyle(fontSize: 13, color: Colors.grey.shade700))])),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 17, color: primaryBlue),
                  ]),
                ),
              ),
            ),
          )),
          const SizedBox(height: 4),
          const Text('*Transport information is illustrative. Live availability, fares and booking are not connected yet.', style: TextStyle(fontSize: 12, color: Colors.black54, height: 1.4)),
        ],
      ),
    );
  }
}
