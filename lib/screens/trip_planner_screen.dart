import 'package:flutter/material.dart';

class TripPlannerScreen extends StatefulWidget {
  const TripPlannerScreen({super.key});

  @override
  State<TripPlannerScreen> createState() => _TripPlannerScreenState();
}

class _TripPlannerScreenState extends State<TripPlannerScreen> {
  String selectedDestination = 'Goa';
  String selectedBudget = 'Moderate';
  String selectedTravelStyle = 'Balanced';

  final List<String> destinations = [
    'Goa',
    'Mumbai',
    'Jaipur',
    'Kerala',
    'Manali',
    'Delhi',
  ];

  final List<String> budgets = ['Budget', 'Moderate', 'Premium'];

  final List<String> travelStyles = ['Relaxed', 'Balanced', 'Adventure'];

  final List<String> interests = [
    'Nature',
    'Food',
    'Culture',
    'Adventure',
    'Shopping',
    'History',
  ];

  final Set<String> selectedInterests = {};

  // ==========================================================
  // GENERATE TRIP
  // ==========================================================

  void generateTrip() {
    if (selectedInterests.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one interest.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Trip Ready! ✨'),
          content: Text(
            'Your ${selectedDestination} trip will be created based on your selected preferences.',
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1565C0),
                foregroundColor: Colors.white,
              ),
              child: const Text('Continue'),
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
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FE),

      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Plan Your Trip',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==================================================
            // HEADER
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
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.auto_awesome, color: Colors.white, size: 28),
                      SizedBox(width: 10),
                      Text(
                        'Saarthi AI Planner',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),

                  Text(
                    'Tell us what you want from your trip and Saarthi will help plan it for you.',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ==================================================
            // DESTINATION
            // ==================================================
            const Text(
              'Where do you want to go?',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Color(0xFF123B65),
              ),
            ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedDestination,
                  isExpanded: true,
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Color(0xFF1565C0),
                  ),
                  items: destinations.map((destination) {
                    return DropdownMenuItem(
                      value: destination,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Color(0xFF1565C0),
                          ),
                          const SizedBox(width: 10),
                          Text(destination),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedDestination = value;
                      });
                    }
                  },
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ==================================================
            // BUDGET
            // ==================================================
            const Text(
              'What is your budget?',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Color(0xFF123B65),
              ),
            ),

            const SizedBox(height: 10),

            Wrap(
              spacing: 10,
              children: budgets.map((budget) {
                final isSelected = selectedBudget == budget;

                return ChoiceChip(
                  label: Text(budget),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      selectedBudget = budget;
                    });
                  },
                  selectedColor: const Color(0xFFBBDEFB),
                  labelStyle: TextStyle(
                    color: isSelected
                        ? const Color(0xFF1565C0)
                        : Colors.grey[700],
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 25),

            // ==================================================
            // TRAVEL STYLE
            // ==================================================
            const Text(
              'What is your travel style?',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Color(0xFF123B65),
              ),
            ),

            const SizedBox(height: 10),

            Wrap(
              spacing: 10,
              children: travelStyles.map((style) {
                final isSelected = selectedTravelStyle == style;

                return ChoiceChip(
                  label: Text(style),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      selectedTravelStyle = style;
                    });
                  },
                  selectedColor: const Color(0xFFBBDEFB),
                  labelStyle: TextStyle(
                    color: isSelected
                        ? const Color(0xFF1565C0)
                        : Colors.grey[700],
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 25),

            // ==================================================
            // INTERESTS
            // ==================================================
            const Text(
              'What are you interested in?',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Color(0xFF123B65),
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              'Select one or more interests.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: interests.map((interest) {
                final isSelected = selectedInterests.contains(interest);

                return FilterChip(
                  label: Text(interest),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedInterests.add(interest);
                      } else {
                        selectedInterests.remove(interest);
                      }
                    });
                  },
                  selectedColor: const Color(0xFFBBDEFB),
                  checkmarkColor: const Color(0xFF1565C0),
                  labelStyle: TextStyle(
                    color: isSelected
                        ? const Color(0xFF1565C0)
                        : Colors.grey[700],
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 30),

            // ==================================================
            // GENERATE BUTTON
            // ==================================================
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: generateTrip,
                icon: const Icon(Icons.auto_awesome),
                label: const Text(
                  'Generate My Trip',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
