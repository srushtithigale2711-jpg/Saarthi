import 'package:flutter/material.dart';

import '../models/trip.dart';
import 'itinerary_screen.dart';

class TripPlannerScreen extends StatefulWidget {
  const TripPlannerScreen({super.key});

  @override
  State<TripPlannerScreen> createState() => _TripPlannerScreenState();
}

class _TripPlannerScreenState extends State<TripPlannerScreen> {
  // ==========================================================
  // DESTINATION
  // ==========================================================

  String selectedDestination = 'Goa';

  // Destination input controller.
  // For now, the user can type any city, country, or destination.
  // In the next step, this will be connected to real destination
  // search / place data.
  final TextEditingController destinationController =
      TextEditingController(text: 'Goa');

  // ==========================================================
  // DATE INFORMATION
  // ==========================================================

  DateTime startDate = DateTime(2026, 9, 16);
  DateTime endDate = DateTime(2026, 9, 22);

  // ==========================================================
  // TRAVELLERS
  // ==========================================================

  int travellers = 1;
  int infants = 0;

  // ==========================================================
  // CHILDREN
  // ==========================================================

  int numberOfChildren = 0;

  final List<int> childrenAges = [];

  // ==========================================================
  // BUDGET
  // ==========================================================

  double selectedBudget = 50000;

  static const double minimumBudget = 5000;
  static const double maximumSliderBudget = 100000;

  final TextEditingController budgetController = TextEditingController(
    text: '50000',
  );

  // ==========================================================
  // INTERESTS
  // ==========================================================

  final List<String> interests = [
    'Nature',
    'Food',
    'Culture',
    'Adventure',
    'Shopping',
    'History',
    'Spiritual',
    'Heritage',
    'Wildlife',
    'Beaches',
    'Wellness',
    'Photography',
    'Festivals',
    'Local Experiences',
  ];

  final Set<String> selectedInterests = {};

  // ==========================================================
  // DISPOSE
  // ==========================================================

  @override
  void dispose() {
    destinationController.dispose();
    budgetController.dispose();
    super.dispose();
  }

  // ==========================================================
  // START DATE PICKER
  // ==========================================================

  Future<void> selectStartDate() async {
    // Use a date-only value for "today".
    // DateTime.now() contains the current time, while dates selected
    // from showDatePicker are at midnight. Using DateTime.now() directly
    // can therefore make today's date invalid.
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    // If the current start date is in the past, open the calendar on today.
    final safeInitialDate = startDate.isBefore(today) ? today : startDate;

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: safeInitialDate,
      firstDate: today,
      lastDate: DateTime(2035),
      helpText: 'Select Start Date',
      cancelText: 'Cancel',
      confirmText: 'Select',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1565C0),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        startDate = pickedDate;

        // Keep the end date after the start date.
        if (!endDate.isAfter(startDate)) {
          endDate = startDate.add(const Duration(days: 1));
        }
      });
    }
  }

  // ==========================================================
  // END DATE PICKER
  // ==========================================================

  Future<void> selectEndDate() async {
    // End date must be at least one day after the start date.
    final minimumEndDate = startDate.add(const Duration(days: 1));

    final safeInitialDate = endDate.isBefore(minimumEndDate)
        ? minimumEndDate
        : endDate;

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: safeInitialDate,
      firstDate: minimumEndDate,
      lastDate: DateTime(2035),
      helpText: 'Select End Date',
      cancelText: 'Cancel',
      confirmText: 'Select',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1565C0),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        endDate = pickedDate;
      });
    }
  }

  // ==========================================================
  // DURATION
  // ==========================================================

  int get tripDuration {
    return endDate.difference(startDate).inDays;
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
  // UPDATE BUDGET FROM TEXT
  // ==========================================================

  void updateBudgetFromText(String value) {
    final cleanValue = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (cleanValue.isEmpty) {
      return;
    }

    final enteredBudget = double.tryParse(cleanValue);

    if (enteredBudget == null) {
      return;
    }

    if (enteredBudget < minimumBudget) {
      setState(() {
        selectedBudget = minimumBudget;
      });
      return;
    }

    setState(() {
      selectedBudget = enteredBudget;
    });
  }

  // ==========================================================
  // ADD CHILD
  // ==========================================================

  void addChild() {
    if (numberOfChildren >= 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'You can add up to 6 children.',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );

      return;
    }

    setState(() {
      numberOfChildren++;
      childrenAges.add(5);
    });
  }

  // ==========================================================
  // REMOVE CHILD
  // ==========================================================

  void removeChild() {
    if (numberOfChildren == 0) {
      return;
    }

    setState(() {
      numberOfChildren--;
      childrenAges.removeLast();
    });
  }

  // ==========================================================
  // CHANGE CHILD AGE
  // ==========================================================

  void changeChildAge(int childIndex, int? age) {
    if (age == null) {
      return;
    }

    setState(() {
      childrenAges[childIndex] = age;
    });
  }

  // ==========================================================
  // GENERATE TRIP
  // ==========================================================

  void generateTrip() {
    final destination = selectedDestination.trim();

    if (destination.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter a destination.',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (!endDate.isAfter(startDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'End date must be after the start date.',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (selectedInterests.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select at least one interest.',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // IMPORTANT:
    // Create one Trip object containing EVERYTHING the user entered.
    // This is what the itinerary screen uses to show the correct
    // duration, dates, travellers, children and budget.
    final trip = Trip(
      destination: destination,
      startDate: startDate,
      endDate: endDate,
      adults: travellers,
      children: numberOfChildren,
      childrenAges: List<int>.from(childrenAges),
      infants: infants,
      budget: selectedBudget,
      interests: List<String>.from(selectedInterests),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItineraryScreen(
          destination: destination,
          budget: formatBudget(selectedBudget),
          travelStyle: 'Balanced',
          interests: Set<String>.from(selectedInterests),
          trip: trip,
        ),
      ),
    );
  }

  // ==========================================================
  // BUILD
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
        title: const Text(
          'Plan Your Trip',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==================================================
            // SAARTHI AI HEADER
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
                      Icon(Icons.auto_awesome, color: Colors.white, size: 29),

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
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 26),

            // ==================================================
            // DESTINATION
            // ==================================================
            const Text(
              'Where do you want to go?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF123B65),
              ),
            ),

            const SizedBox(height: 10),

            Container(
              height: 58,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFFE0E7EF)),
              ),
              child: TextField(
                controller: destinationController,
                textCapitalization: TextCapitalization.words,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF123B65),
                ),
                onChanged: (value) {
                  setState(() {
                    selectedDestination = value.trim();
                  });
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.location_on,
                    color: Color(0xFF1565C0),
                    size: 23,
                  ),
                  hintText: 'Enter a city or country',
                  hintStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF78909C),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 17),
                ),
              ),
            ),

            const SizedBox(height: 28),

            // ==================================================
            // TRIP DATES
            // ==================================================
            const Text(
              'When is your trip?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF123B65),
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: dateCard(
                    title: 'Start Date',
                    date: formatDate(startDate),
                    onTap: selectStartDate,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: dateCard(
                    title: 'End Date',
                    date: formatDate(endDate),
                    onTap: selectEndDate,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ==================================================
            // TRIP INFORMATION
            // ==================================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  // DURATION
                  Expanded(
                    child: infoItem(
                      icon: Icons.access_time,
                      title: 'Duration',
                      value: '$tripDuration Days',
                    ),
                  ),

                  Container(
                    height: 55,
                    width: 1,
                    color: const Color(0xFFB0C4D8),
                  ),

                  // TRAVELLERS
                  Expanded(child: travellerSelector()),

                  Container(
                    height: 55,
                    width: 1,
                    color: const Color(0xFFB0C4D8),
                  ),

                  // GUEST SUMMARY
                  Expanded(
                    child: guestSummary(),
                  ),
                ],
              ),
            ),

            // ==================================================
            // CHILDREN AGE SECTION
            // ==================================================
            if (numberOfChildren > 0) ...[
              const SizedBox(height: 18),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFD7E1EA)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Children\'s Ages',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF123B65),
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      'Enter the age of each child.',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF607D8B),
                      ),
                    ),

                    const SizedBox(height: 12),

                    ...List.generate(numberOfChildren, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: childAgeSelector(
                          childNumber: index + 1,
                          age: childrenAges[index],
                          onChanged: (age) {
                            changeChildAge(index, age);
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 28),

            // ==================================================
            // BUDGET
            // ==================================================
            const Text(
              'What is your budget?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF123B65),
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              'Choose a range or enter your exact budget.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF607D8B),
              ),
            ),

            const SizedBox(height: 14),

            // ==================================================
            // MANUAL BUDGET INPUT
            // ==================================================
            Container(
              height: 58,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFFB0BEC5)),
              ),
              child: TextField(
                controller: budgetController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: false,
                ),
                onChanged: updateBudgetFromText,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF123B65),
                ),
                decoration: const InputDecoration(
                  prefixText: '₹ ',
                  prefixStyle: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1565C0),
                  ),
                  hintText: 'Enter your budget',
                  hintStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF78909C),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 15,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 18),

            // ==================================================
            // BUDGET RANGE LABELS
            // ==================================================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  '₹5,000',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF123B65),
                  ),
                ),

                Text(
                  '₹1,00,000+',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF123B65),
                  ),
                ),
              ],
            ),

            // ==================================================
            // BUDGET SLIDER
            // ==================================================
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: const Color(0xFF1976D2),
                inactiveTrackColor: const Color(0xFFC8D0D9),
                thumbColor: const Color(0xFF1976D2),
                trackHeight: 7,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 11),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 22),
              ),
              child: Slider(
                value: selectedBudget.clamp(minimumBudget, maximumSliderBudget),
                min: minimumBudget,
                max: maximumSliderBudget,
                divisions: 95,
                label: selectedBudget > maximumSliderBudget
                    ? '₹1,00,000+'
                    : formatBudget(selectedBudget),
                onChanged: (value) {
                  setState(() {
                    selectedBudget = value;

                    budgetController.text = value.round().toString();

                    budgetController.selection = TextSelection.fromPosition(
                      TextPosition(offset: budgetController.text.length),
                    );
                  });
                },
              ),
            ),

            // ==================================================
            // CURRENT BUDGET DISPLAY
            // ==================================================
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  formatBudget(selectedBudget),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1565C0),
                  ),
                ),
              ),
            ),

            // ==================================================
            // CUSTOM BUDGET MESSAGE
            // ==================================================
            if (selectedBudget > maximumSliderBudget)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Center(
                  child: Text(
                    'Custom budget above ₹1,00,000',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF607D8B),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 30),

            // ==================================================
            // INTERESTS
            // ==================================================
            const Text(
              'What are you interested in?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF123B65),
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              'Select one or more interests.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF607D8B),
              ),
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 9,
              runSpacing: 10,
              children: interests.map((interest) {
                final isSelected = selectedInterests.contains(interest);

                return FilterChip(
                  label: Text(
                    interest,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? const Color(0xFF1565C0)
                          : const Color(0xFF455A64),
                    ),
                  ),
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
                  backgroundColor: Colors.white,
                  checkmarkColor: const Color(0xFF1565C0),
                  side: BorderSide(
                    color: isSelected
                        ? const Color(0xFF90CAF9)
                        : const Color(0xFFD0D7DE),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 32),

            // ==================================================
            // GENERATE BUTTON
            // ==================================================
            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton.icon(
                onPressed: generateTrip,
                icon: const Icon(Icons.auto_awesome, size: 22),
                label: const Text(
                  'Generate My Trip',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  foregroundColor: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
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
  // DATE CARD
  // ==========================================================

  Widget dateCard({
    required String title,
    required String date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFFCFD8E3)),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Icon(
                Icons.calendar_month,
                color: Color(0xFF1565C0),
                size: 24,
              ),
            ),

            const SizedBox(width: 9),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF607D8B),
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF123B65),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // INFORMATION ITEM
  // ==========================================================

  Widget infoItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF1565C0), size: 27),

        const SizedBox(height: 5),

        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF607D8B),
          ),
        ),

        const SizedBox(height: 2),

        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF123B65),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // TRAVELLER SELECTOR
  // ==========================================================

  Future<void> _showTravellerSelector() async {
    int tempAdults = travellers;
    int tempChildren = numberOfChildren;
    int tempInfants = infants;

    List<int> tempChildrenAges = List<int>.from(childrenAges);
    while (tempChildrenAges.length < tempChildren) {
      tempChildrenAges.add(5);
    }
    while (tempChildrenAges.length > tempChildren) {
      tempChildrenAges.removeLast();
    }

    await showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.white,
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 24,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 800,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ==================================================
                      // ADULTS
                      // ==================================================
                      const Text(
                        'ADULTS (12y +)',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF444444),
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        'on the day of travel',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF9E9E9E),
                        ),
                      ),
                      const SizedBox(height: 9),

                      _travellerNumberRow(
                        selected: tempAdults,
                        numbers: List.generate(9, (index) => index + 1),
                        extraLabel: '>9',
                        extraSelected: tempAdults > 9,
                        onSelected: (value) {
                          setDialogState(() {
                            tempAdults = value;
                          });
                        },
                        onExtraSelected: () async {
                          final value = await _askForCustomCount(
                            title: 'Adults',
                            minimum: 10,
                            maximum: 99,
                            initialValue: tempAdults > 9 ? tempAdults : 10,
                          );
                          if (value != null) {
                            setDialogState(() {
                              tempAdults = value;
                            });
                          }
                        },
                      ),

                      const SizedBox(height: 25),

                      // ==================================================
                      // CHILDREN + INFANTS
                      // ==================================================
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _travellerCategory(
                              title: 'CHILDREN (2y - 12y)',
                              selected: tempChildren,
                              numbers: List.generate(7, (index) => index),
                              extraLabel: '>6',
                              extraSelected: tempChildren > 6,
                              onSelected: (value) {
                                setDialogState(() {
                                  tempChildren = value;

                                  while (tempChildrenAges.length < tempChildren) {
                                    tempChildrenAges.add(5);
                                  }

                                  while (tempChildrenAges.length > tempChildren) {
                                    tempChildrenAges.removeLast();
                                  }
                                });
                              },
                              onExtraSelected: () async {
                                final value = await _askForCustomCount(
                                  title: 'Children',
                                  minimum: 7,
                                  maximum: 20,
                                  initialValue:
                                      tempChildren > 6 ? tempChildren : 7,
                                );
                                if (value != null) {
                                  setDialogState(() {
                                    tempChildren = value;

                                    while (tempChildrenAges.length < tempChildren) {
                                      tempChildrenAges.add(5);
                                    }

                                    while (tempChildrenAges.length > tempChildren) {
                                      tempChildrenAges.removeLast();
                                    }
                                  });
                                }
                              },
                            ),
                          ),

                          const SizedBox(width: 18),

                          Expanded(
                            child: _travellerCategory(
                              title: 'INFANTS (below 2y)',
                              selected: tempInfants,
                              numbers: List.generate(7, (index) => index),
                              extraLabel: '>6',
                              extraSelected: tempInfants > 6,
                              onSelected: (value) {
                                setDialogState(() {
                                  tempInfants = value;
                                });
                              },
                              onExtraSelected: () async {
                                final value = await _askForCustomCount(
                                  title: 'Infants',
                                  minimum: 7,
                                  maximum: 20,
                                  initialValue:
                                      tempInfants > 6 ? tempInfants : 7,
                                );
                                if (value != null) {
                                  setDialogState(() {
                                    tempInfants = value;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),

                      // ==================================================
                      // CHILDREN'S AGES
                      // ==================================================
                      if (tempChildren > 0) ...[
                        const SizedBox(height: 20),
                        const Text(
                          "CHILDREN'S AGES",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF444444),
                          ),
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          'Select the age of each child on the day of travel',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF9E9E9E),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: List.generate(
                            tempChildren,
                            (index) => _dialogChildAgeSelector(
                              childNumber: index + 1,
                              age: tempChildrenAges[index],
                              onChanged: (value) {
                                setDialogState(() {
                                  tempChildrenAges[index] = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 25),

                      // ==================================================
                      // APPLY BUTTON
                      // ==================================================
                      Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          height: 41,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                travellers = tempAdults;
                                numberOfChildren = tempChildren;
                                infants = tempInfants;

                                childrenAges
                                  ..clear()
                                  ..addAll(tempChildrenAges);
                              });

                              Navigator.pop(dialogContext);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1976D2),
                              foregroundColor: Colors.white,
                              elevation: 3,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: const Text(
                              'APPLY',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ==========================================================
  // TRAVELLER CATEGORY
  // ==========================================================

  Widget _travellerCategory({
    required String title,
    required int selected,
    required List<int> numbers,
    required String extraLabel,
    required bool extraSelected,
    required ValueChanged<int> onSelected,
    required VoidCallback onExtraSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF444444),
          ),
        ),
        const SizedBox(height: 3),
        const Text(
          'on the day of travel',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF9E9E9E),
          ),
        ),
        const SizedBox(height: 9),
        _travellerNumberRow(
          selected: selected,
          numbers: numbers,
          extraLabel: extraLabel,
          extraSelected: extraSelected,
          onSelected: onSelected,
          onExtraSelected: onExtraSelected,
        ),
      ],
    );
  }

  // ==========================================================
  // NUMBER SELECTOR ROW
  // ==========================================================

  Widget _travellerNumberRow({
    required int selected,
    required List<int> numbers,
    required String extraLabel,
    required bool extraSelected,
    required ValueChanged<int> onSelected,
    required VoidCallback onExtraSelected,
  }) {
    return SizedBox(
      height: 47,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            ...numbers.map(
              (number) => Padding(
                padding: const EdgeInsets.only(right: 3),
                child: _travellerNumberBox(
                  label: '$number',
                  selected: selected == number,
                  onTap: () => onSelected(number),
                ),
              ),
            ),
            _travellerNumberBox(
              label: extraLabel,
              selected: extraSelected,
              width: 49,
              onTap: onExtraSelected,
            ),
          ],
        ),
      ),
    );
  }

  Widget _travellerNumberBox({
    required String label,
    required bool selected,
    required VoidCallback onTap,
    double width = 43,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          width: width,
          height: 47,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF1295F3) : Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: selected
                  ? const Color(0xFF1295F3)
                  : const Color(0xFFE0E0E0),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x16000000),
                blurRadius: 7,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: selected ? FontWeight.bold : FontWeight.w500,
              color: selected ? Colors.white : const Color(0xFF4A4A4A),
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // CUSTOM TRAVELLER COUNT
  // ==========================================================

  Future<int?> _askForCustomCount({
    required String title,
    required int minimum,
    required int maximum,
    required int initialValue,
  }) async {
    final controller = TextEditingController(
      text: initialValue.toString(),
    );

    return showDialog<int>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Number of $title'),
          content: TextField(
            controller: controller,
            autofocus: true,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: '$minimum - $maximum',
              border: const OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('CANCEL'),
            ),
            ElevatedButton(
              onPressed: () {
                final value = int.tryParse(controller.text.trim());

                if (value == null || value < minimum || value > maximum) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Please enter a number from $minimum to $maximum.',
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  return;
                }

                Navigator.pop(dialogContext, value);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // ==========================================================
  // NUMBER SELECTOR ROW
  // ==========================================================

  Widget travellerNumberSelector({
    required int selected,
    required List<int> numbers,
    required String extraLabel,
    required VoidCallback onExtraSelected,
    required ValueChanged<int> onSelected,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...numbers.map(
            (number) => Padding(
              padding: const EdgeInsets.only(right: 5),
              child: InkWell(
                onTap: () => onSelected(number),
                borderRadius: BorderRadius.circular(7),
                child: Container(
                  width: 43,
                  height: 45,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected == number
                        ? const Color(0xFF2196F3)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(
                      color: selected == number
                          ? const Color(0xFF2196F3)
                          : const Color(0xFFE0E0E0),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x12000000),
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    '$number',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: selected == number
                          ? FontWeight.bold
                          : FontWeight.w500,
                      color: selected == number
                          ? Colors.white
                          : const Color(0xFF4A4A4A),
                    ),
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: onExtraSelected,
            borderRadius: BorderRadius.circular(7),
            child: Container(
              width: 50,
              height: 45,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(7),
                border: Border.all(color: const Color(0xFFE0E0E0)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x12000000),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                extraLabel,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF4A4A4A),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // TRAVELLER CARD
  // ==========================================================

  Widget travellerSelector() {
    return InkWell(
      onTap: _showTravellerSelector,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          const Icon(
            Icons.people,
            color: Color(0xFF1565C0),
            size: 27,
          ),
          const SizedBox(height: 5),
          const Text(
            'Travellers',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF607D8B),
            ),
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  '$travellers Adult${travellers == 1 ? '' : 's'}',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF123B65),
                  ),
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 18,
                color: Color(0xFF1565C0),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // GUEST SUMMARY
  // ==========================================================

  Widget guestSummary() {
    final total = travellers + numberOfChildren + infants;

    return InkWell(
      onTap: _showTravellerSelector,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          const Icon(
            Icons.groups_outlined,
            color: Color(0xFF1565C0),
            size: 27,
          ),
          const SizedBox(height: 5),
          const Text(
            'Total Guests',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF607D8B),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '$total',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF123B65),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // CHILD AGE SELECTOR INSIDE TRAVELLER LAYER
  // ==========================================================

  Widget _dialogChildAgeSelector({
    required int childNumber,
    required int age,
    required ValueChanged<int> onChanged,
  }) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Child $childNumber',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF444444),
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'Age',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF888888),
            ),
          ),
          const SizedBox(width: 4),
          DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: age,
              isDense: true,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                size: 18,
                color: Color(0xFF1565C0),
              ),
              items: List.generate(11, (index) {
                final childAge = index + 2;
                return DropdownMenuItem<int>(
                  value: childAge,
                  child: Text(
                    '$childAge',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF123B65),
                    ),
                  ),
                );
              }),
              onChanged: (value) {
                if (value != null) {
                  onChanged(value);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // CHILD AGE SELECTOR
  // ==========================================================

  Widget childAgeSelector({
    required int childNumber,
    required int age,
    required ValueChanged<int?> onChanged,
  }) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F9FE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD5E0EA)),
      ),
      child: Row(
        children: [
          const Icon(Icons.child_friendly, color: Color(0xFF1565C0), size: 22),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              'Child $childNumber',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF123B65),
              ),
            ),
          ),

          const Text(
            'Age',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF607D8B),
            ),
          ),

          const SizedBox(width: 8),

          DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: age,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xFF1565C0),
              ),
              items: List.generate(17, (index) {
                final childAge = index + 1;

                return DropdownMenuItem<int>(
                  value: childAge,
                  child: Text(
                    '$childAge',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF123B65),
                    ),
                  ),
                );
              }),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
