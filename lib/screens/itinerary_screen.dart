import 'package:flutter/material.dart';

import '../models/trip.dart';

class ItineraryScreen extends StatelessWidget {
  // Legacy fields are kept so existing navigation code remains compatible.
  final String destination;
  final String budget;
  final String travelStyle;
  final Set<String> interests;

  // The complete trip selected by the user on Plan Your Trip.
  final Trip trip;

  const ItineraryScreen({
    super.key,
    required this.destination,
    required this.budget,
    required this.travelStyle,
    required this.interests,
    required this.trip,
  });

  // ==========================================================
  // VALUES FROM THE USER'S TRIP
  // ==========================================================

  // All itinerary values come directly from the user's Trip.
  String get tripDestination => trip.destination;

  String get tripBudget => formatBudget(trip.budget);

  DateTime get tripStartDate => trip.startDate;

  DateTime get tripEndDate => trip.endDate;

  int get tripDuration {
    // Example: 25 Sep -> 30 Sep = 5 itinerary days.
    final days = trip.endDate.difference(trip.startDate).inDays;
    return days < 1 ? 1 : days;
  }

  int get totalTravellers => trip.totalTravellers;

  int get adults => trip.adults;

  int get children => trip.children;

  int get infants => trip.infants;

  List<int> get childrenAges => trip.childrenAges;

  List<String> get selectedInterestList => trip.interests;

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
          'Your Itinerary',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
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
              padding: const EdgeInsets.all(18),
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
                  const Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 32,
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Your Saarthi Journey ✨',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    '$tripDestination • $tripDuration Days • $tripBudget',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'A personalised plan based on your trip dates, travellers, budget and interests.',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ==================================================
            // YOUR TRIP
            // ==================================================

            const Text(
              'Your Trip',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF123B65),
              ),
            ),

            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  summaryRow(
                    Icons.location_on,
                    'Destination',
                    tripDestination,
                  ),

                  const Divider(height: 20),

                  summaryRow(
                    Icons.calendar_month,
                    'Travel Dates',
                    '${formatDate(tripStartDate)} – ${formatDate(tripEndDate)}',
                  ),

                  const Divider(height: 20),

                  summaryRow(
                    Icons.access_time,
                    'Duration',
                    '$tripDuration ${tripDuration == 1 ? 'day' : 'days'}',
                  ),

                  const Divider(height: 20),

                  summaryRow(
                    Icons.groups,
                    'Travellers',
                    travellerSummary(),
                  ),

                  const Divider(height: 20),

                  summaryRow(
                    Icons.account_balance_wallet,
                    'Budget',
                    tripBudget,
                  ),

                  const Divider(height: 20),

                  summaryRow(
                    Icons.favorite,
                    'Interests',
                    selectedInterestList.isEmpty
                        ? 'Not specified'
                        : selectedInterestList.join(', '),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ==================================================
            // AI NOTE
            // ==================================================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFBBDEFB),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    color: Color(0xFF1565C0),
                    size: 25,
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      'Saarthi has planned this $tripDuration-day trip around ${selectedInterestList.join(', ')} for your $travellerSummary and $tripBudget budget.',
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF123B65),
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ==================================================
            // DAY-BY-DAY ITINERARY
            // ==================================================

            const Text(
              'Day-by-Day Plan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF123B65),
              ),
            ),

            const SizedBox(height: 12),

            ...List.generate(
              tripDuration,
              (index) => buildDayPlan(index),
            ),

            const SizedBox(height: 10),

            // ==================================================
            // RE-OPTIMISE
            // ==================================================

            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Saarthi will re-optimise this itinerary using your latest preferences.',
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                icon: const Icon(Icons.auto_awesome),
                label: const Text(
                  'Re-optimise with Saarthi AI',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF1565C0),
                  side: const BorderSide(
                    color: Color(0xFF1565C0),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // DAY PLAN
  // ==========================================================

  Widget buildDayPlan(int dayIndex) {
    final dayNumber = dayIndex + 1;

    final date = tripStartDate.add(
      Duration(days: dayIndex),
    );

    final activities = buildActivitiesForDay(dayIndex);

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1565C0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'DAY $dayNumber',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  formatDate(date),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF123B65),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          ...activities.map(
            (activity) => itineraryCard(
              time: activity['time'] as String,
              title: activity['title'] as String,
              description: activity['description'] as String,
              icon: activity['icon'] as IconData,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // PERSONALIZED ACTIVITY TEMPLATES
  // ==========================================================

  List<Map<String, dynamic>> buildActivitiesForDay(int dayIndex) {
    final list = selectedInterestList;

    final interest =
        list.isEmpty ? 'Culture' : list[dayIndex % list.length];

    final secondInterest = list.length > 1
        ? list[(dayIndex + 1) % list.length]
        : interest;

    if (dayIndex == 0) {
      return [
        {
          'time': '09:00 AM',
          'title': 'Arrival & Check-in',
          'description':
              'Arrive in $tripDestination, settle into your stay and get ready for the journey.',
          'icon': Icons.hotel,
        },
        {
          'time': '01:00 PM',
          'title': '$interest Experience',
          'description':
              'Start exploring $tripDestination with activities selected around your interest in $interest.',
          'icon': iconForInterest(interest),
        },
        {
          'time': '04:00 PM',
          'title': '$secondInterest Exploration',
          'description':
              'Discover a local experience in $tripDestination that matches your interest in $secondInterest.',
          'icon': iconForInterest(secondInterest),
        },
        {
          'time': '07:30 PM',
          'title': 'Local Evening Experience',
          'description':
              'Enjoy the local atmosphere and a relaxed evening before returning to your stay.',
          'icon': Icons.nightlife,
        },
      ];
    }

    return [
      {
        'time': '08:00 AM',
        'title': 'Breakfast & Start of Day',
        'description':
            'Begin Day ${dayIndex + 1} with breakfast and prepare for the day ahead.',
        'icon': Icons.free_breakfast,
      },
      {
        'time': '10:00 AM',
        'title': '$interest Highlights',
        'description':
            'Explore $tripDestination through experiences related to your selected interest: $interest.',
        'icon': iconForInterest(interest),
      },
      {
        'time': '02:00 PM',
        'title': '$secondInterest Experience',
        'description':
            'Continue with a $secondInterest-focused experience selected for your trip preferences.',
        'icon': iconForInterest(secondInterest),
      },
      {
        'time': '06:00 PM',
        'title': 'Leisure & Local Discovery',
        'description':
            'Use the evening to relax, explore nearby places and enjoy local food or shopping.',
        'icon': Icons.explore,
      },
    ];
  }

  IconData iconForInterest(String interest) {
    switch (interest.toLowerCase()) {
      case 'nature':
        return Icons.nature;
      case 'food':
        return Icons.restaurant;
      case 'culture':
        return Icons.museum;
      case 'adventure':
        return Icons.hiking;
      case 'shopping':
        return Icons.shopping_bag;
      case 'history':
        return Icons.account_balance;
      case 'spiritual':
        return Icons.self_improvement;
      case 'heritage':
        return Icons.account_balance;
      case 'wildlife':
        return Icons.pets;
      case 'beaches':
        return Icons.beach_access;
      case 'wellness':
        return Icons.spa;
      case 'photography':
        return Icons.camera_alt;
      case 'festivals':
        return Icons.celebration;
      case 'local experiences':
        return Icons.people;
      default:
        return Icons.place;
    }
  }

  // ==========================================================
  // TRAVELLER SUMMARY
  // ==========================================================

  String travellerSummary() {
    final parts = <String>[];

    parts.add(
      '$adults adult${adults == 1 ? '' : 's'}',
    );

    if (children > 0) {
      parts.add(
        '$children child${children == 1 ? '' : 'ren'}',
      );
    }

    if (infants > 0) {
      parts.add(
        '$infants infant${infants == 1 ? '' : 's'}',
      );
    }

    return parts.join(' • ');
  }

  // ==========================================================
  // DATE FORMAT
  // ==========================================================

  String formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  // ==========================================================
  // BUDGET FORMAT
  // ==========================================================

  String formatBudget(double amount) {
    final value = amount.round();

    final formatted = value.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+$)'),
      (match) => '${match[1]},',
    );

    return '₹$formatted';
  }

  // ==========================================================
  // SUMMARY ROW
  // ==========================================================

  Widget summaryRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: const Color(0xFF1565C0),
            size: 22,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF90A4AE),
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF123B65),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // ITINERARY CARD
  // ==========================================================

  Widget itineraryCard({
    required String time,
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.045),
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF1565C0),
              size: 23,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF1565C0),
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF123B65),
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
