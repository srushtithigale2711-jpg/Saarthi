import 'dart:async';

import 'package:flutter/material.dart';

import 'trip_planner_screen.dart';
import 'map_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ==========================================================
  // CONTROLLERS
  // ==========================================================

  final TextEditingController destinationController =
      TextEditingController(text: 'Goa');

  final PageController bannerController = PageController();

  Timer? bannerTimer;

  int currentBanner = 0;

  // ==========================================================
  // COLORS
  // ==========================================================

  static const Color primaryBlue = Color(0xFF1565C0);
  static const Color deepBlue = Color(0xFF0D47A1);
  static const Color darkBlue = Color(0xFF123B65);
  static const Color skyBlue = Color(0xFF42A5F5);
  static const Color lightBlue = Color(0xFFE3F2FD);
  static const Color background = Color(0xFFF1F7FD);

  // ==========================================================
  // HERO BANNER DATA
  // ==========================================================

  final List<Map<String, String>> travelBanners = [
    {
      'image':
          'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?auto=format&fit=crop&w=1200&q=85',
      'title': 'Discover Beautiful Beaches',
      'subtitle': 'Plan unforgettable coastal journeys with Safar Saathi.',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1200&q=85',
      'title': 'Explore the Mountains',
      'subtitle': 'Find breathtaking destinations and experiences.',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1477587458883-47145ed94245?auto=format&fit=crop&w=1200&q=85',
      'title': 'Experience New Cultures',
      'subtitle': 'Discover places, food, heritage and local experiences.',
    },
  ];

  // ==========================================================
  // DESTINATION DATA
  // ==========================================================

  final List<Map<String, String>> destinations = [
    {
      'name': 'Goa',
      'subtitle': 'Beaches & nightlife',
      'image':
          'https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?auto=format&fit=crop&w=700&q=80',
    },
    {
      'name': 'Manali',
      'subtitle': 'Mountains & adventure',
      'image':
          'https://images.unsplash.com/photo-1595815771614-ade9d652a65d?auto=format&fit=crop&w=700&q=80',
    },
    {
      'name': 'Jaipur',
      'subtitle': 'Heritage & culture',
      'image':
          'https://images.unsplash.com/photo-1477587458883-47145ed94245?auto=format&fit=crop&w=700&q=80',
    },
  ];

  // ==========================================================
  // SELECTED DESTINATION
  // ==========================================================

  String get selectedPlace {
    final destination = destinationController.text.trim();

    return destination.isEmpty ? 'your destination' : destination;
  }

  // ==========================================================
  // INIT STATE
  // ==========================================================

  @override
  void initState() {
    super.initState();

    bannerTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) {
        if (!bannerController.hasClients) return;

        currentBanner =
            (currentBanner + 1) % travelBanners.length;

        bannerController.animateToPage(
          currentBanner,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOut,
        );
      },
    );
  }

  // ==========================================================
  // DISPOSE
  // ==========================================================

  @override
  void dispose() {
    bannerTimer?.cancel();
    bannerController.dispose();
    destinationController.dispose();
    super.dispose();
  }

  // ==========================================================
  // FEATURE BOTTOM SHEET
  // ==========================================================

  void openFeature(
    String title,
    String description,
    IconData icon,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(
            24,
            25,
            24,
            30,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle
                Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 25),

                // Icon
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: lightBlue,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Icon(
                    icon,
                    color: primaryBlue,
                    size: 38,
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: darkBlue,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  '$description\n\nSelected destination: $selectedPlace',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 22),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==========================================================
  // OPEN MAP
  // ==========================================================

  void openMap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MapScreen(),
      ),
    );
  }

  // ==========================================================
  // OPEN TRIP PLANNER
  // ==========================================================

  void openTripPlanner() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TripPlannerScreen(),
      ),
    );
  }

  // ==========================================================
  // SELECT DESTINATION
  // ==========================================================

  void selectDestination(String destination) {
    setState(() {
      destinationController.text = destination;
    });

    FocusScope.of(context).unfocus();

    showMessage(
      context,
      '$destination selected as your destination.',
    );
  }

  // ==========================================================
  // HOME SCREEN
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      // ======================================================
      // APP BAR
      // ======================================================

      appBar: AppBar(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,

        title: const Row(
          children: [
            Icon(
              Icons.travel_explore,
              size: 28,
            ),

            SizedBox(width: 10),

            Text(
              'Safar Saathi',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        actions: [
          IconButton(
            onPressed: () {
              showMessage(
                context,
                'No new notifications.',
              );
            },
            icon: const Icon(
              Icons.notifications_none,
              size: 27,
            ),
          ),
        ],
      ),

      // ======================================================
      // BODY
      // ======================================================

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          16,
          18,
          16,
          110,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==================================================
            // GREETING
            // ==================================================

            const Text(
              'Hello, Traveller! 👋',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
                color: darkBlue,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              'Plan your perfect journey with Safar Saathi.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 18),

            // ==================================================
            // DYNAMIC IMAGE CAROUSEL
            // ==================================================

            _heroBanner(),

            const SizedBox(height: 22),

            // ==================================================
            // DESTINATION SEARCH
            // ==================================================

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    deepBlue,
                    primaryBlue,
                    skyBlue,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(23),
                boxShadow: [
                  BoxShadow(
                    color: primaryBlue.withValues(
                      alpha: 0.25,
                    ),
                    blurRadius: 15,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 22,
                      ),
                      SizedBox(width: 7),
                      Text(
                        'Where are you going?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 13),

                  Container(
                    height: 54,
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(15),
                    ),
                    child: TextField(
                      controller:
                          destinationController,
                      textInputAction:
                          TextInputAction.done,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: darkBlue,
                      ),
                      decoration:
                          const InputDecoration(
                        border: InputBorder.none,
                        hintText:
                            'Enter any destination',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: primaryBlue,
                        ),
                      ),
                      onChanged: (_) {
                        setState(() {});
                      },
                      onSubmitted: (_) {
                        FocusScope.of(context)
                            .unfocus();
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ==================================================
            // DISCOVER SOMETHING NEW
            // THIS CARD IS NOW CLICKABLE
            // ==================================================

            GestureDetector(
              onTap: () {
                openFeature(
                  'Discover Something New',
                  'Explore destinations, tourist attractions, local food, cultural experiences and exciting places tailored to your journey.',
                  Icons.travel_explore,
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: 0.06,
                      ),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Icon box
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        gradient:
                            const LinearGradient(
                          colors: [
                            Color(0xFFDFF1FF),
                            Color(0xFFC7E7FF),
                          ],
                        ),
                        borderRadius:
                            BorderRadius.circular(17),
                      ),
                      child: const Icon(
                        Icons.travel_explore,
                        color: primaryBlue,
                        size: 31,
                      ),
                    ),

                    const SizedBox(width: 14),

                    // Text
                    const Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Discover something new',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight:
                                  FontWeight.bold,
                              color: darkBlue,
                            ),
                          ),

                          SizedBox(height: 5),

                          Text(
                            'Explore destinations, attractions and experiences tailored for you.',
                            style: TextStyle(
                              fontSize: 11,
                              height: 1.35,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Click arrow
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: lightBlue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                        color: primaryBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 27),

            // ==================================================
            // POPULAR DESTINATIONS
            // ==================================================

            _sectionHeader(
              title: 'Popular destinations',
              subtitle: 'Explore places travellers love',
              onTap: () {
                openFeature(
                  'Popular Destinations',
                  'Explore popular destinations and discover your next journey.',
                  Icons.location_city,
                );
              },
            ),

            const SizedBox(height: 14),

            SizedBox(
              height: 190,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics:
                    const BouncingScrollPhysics(),
                itemCount: destinations.length,
                separatorBuilder:
                    (_, __) =>
                        const SizedBox(width: 13),
                itemBuilder: (context, index) {
                  final destination =
                      destinations[index];

                  return _destinationCard(
                    name:
                        destination['name']!,
                    subtitle:
                        destination['subtitle']!,
                    image:
                        destination['image']!,
                    onTap: () {
                      selectDestination(
                        destination['name']!,
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 28),

            // ==================================================
            // TRAVEL SERVICES
            // ==================================================

            _sectionHeader(
              title: 'Travel Services',
              subtitle: 'Everything you need for your journey',
            ),

            const SizedBox(height: 14),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.25,
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

                serviceCard(
                  icon: Icons.card_travel,
                  title: 'Packages',
                  subtitle: 'Plan your trip',
                  onTap: openTripPlanner,
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

            const SizedBox(height: 28),

            // ==================================================
            // AI TRAVEL COMPANION
            // ==================================================

            GestureDetector(
              onTap: () {
                openFeature(
                  'Safar Saathi AI',
                  'Get intelligent travel recommendations based on your destination, interests and preferences.',
                  Icons.auto_awesome,
                );
              },
              child: Container(
                padding: const EdgeInsets.all(19),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF0D47A1),
                      Color(0xFF1976D2),
                      Color(0xFF42A5F5),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius:
                      BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: primaryBlue.withValues(
                        alpha: 0.25,
                      ),
                      blurRadius: 15,
                      offset: const Offset(0, 7),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: Colors.white
                            .withValues(alpha: 0.18),
                        borderRadius:
                            BorderRadius.circular(17),
                      ),
                      child: const Icon(
                        Icons.auto_awesome,
                        color: Colors.white,
                        size: 31,
                      ),
                    ),

                    const SizedBox(width: 14),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AI Travel Companion',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 5),

                          Text(
                            'Get personalised travel ideas with Safar Saathi AI.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 17,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            // ==================================================
            // SAFETY & EMERGENCY
            // ==================================================

            _sectionHeader(
              title: 'Safety & Emergency',
              subtitle:
                  'Stay safe and connected while travelling',
            ),

            const SizedBox(height: 14),

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
                    icon:
                        Icons.warning_amber_rounded,
                    title: 'Emergency',
                    onTap: () {
                      openFeature(
                        'Emergency Assistance',
                        'Quick access to emergency assistance.',
                        Icons
                            .warning_amber_rounded,
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 13),

            // ==================================================
            // MAP BUTTON
            // ==================================================

            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton.icon(
                onPressed: openMap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: deepBlue,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(17),
                  ),
                ),
                icon: const Icon(
                  Icons.my_location,
                  size: 23,
                ),
                label: const Text(
                  'OPEN SAFAR SAATHI MAP',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.7,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // ======================================================
      // AI FLOATING BUTTON
      // ======================================================

      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: () {
          openFeature(
            'Safar Saathi AI',
            'Get intelligent travel recommendations based on your destination, interests and preferences.',
            Icons.auto_awesome,
          );
        },
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 5,
        icon: const Icon(Icons.auto_awesome),
        label: const Text(
          'AI Recommendations',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // HERO BANNER
  // ==========================================================

  Widget _heroBanner() {
    return Column(
      children: [
        SizedBox(
          height: 205,
          child: PageView.builder(
            controller: bannerController,
            itemCount: travelBanners.length,
            onPageChanged: (index) {
              setState(() {
                currentBanner = index;
              });
            },
            itemBuilder: (context, index) {
              final banner =
                  travelBanners[index];

              return Container(
                margin:
                    const EdgeInsets.symmetric(
                  horizontal: 1,
                ),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(23),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: 0.12,
                      ),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(23),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        banner['image']!,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) {
                          return Container(
                            decoration:
                                const BoxDecoration(
                              gradient:
                                  LinearGradient(
                                colors: [
                                  deepBlue,
                                  skyBlue,
                                ],
                              ),
                            ),
                            child: const Icon(
                              Icons.landscape,
                              color: Colors.white,
                              size: 60,
                            ),
                          );
                        },
                        loadingBuilder:
                            (context, child, progress) {
                          if (progress == null) {
                            return child;
                          }

                          return Container(
                            decoration:
                                const BoxDecoration(
                              gradient:
                                  LinearGradient(
                                colors: [
                                  deepBlue,
                                  skyBlue,
                                ],
                              ),
                            ),
                            child: const Center(
                              child:
                                  CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      ),

                      // Dark overlay
                      Container(
                        decoration:
                            BoxDecoration(
                          gradient:
                              LinearGradient(
                            begin:
                                Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withValues(
                                alpha: 0.65,
                              ),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),

                      // Banner text
                      Positioned(
                        left: 18,
                        right: 18,
                        bottom: 17,
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              banner['title']!,
                              style:
                                  const TextStyle(
                                color: Colors.white,
                                fontSize: 21,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              banner['subtitle']!,
                              style:
                                  const TextStyle(
                                color:
                                    Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 10),

        // Carousel indicators
        Row(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: List.generate(
            travelBanners.length,
            (index) {
              final isSelected =
                  currentBanner == index;

              return AnimatedContainer(
                duration: const Duration(
                  milliseconds: 250,
                ),
                margin:
                    const EdgeInsets.symmetric(
                  horizontal: 3,
                ),
                width: isSelected ? 22 : 7,
                height: 7,
                decoration: BoxDecoration(
                  color: isSelected
                      ? primaryBlue
                      : Colors.grey.shade300,
                  borderRadius:
                      BorderRadius.circular(10),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // DESTINATION CARD
  // ==========================================================

  Widget _destinationCard({
    required String name,
    required String subtitle,
    required String image,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 155,
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                image,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) {
                  return Container(
                    color: skyBlue,
                    child: const Icon(
                      Icons.image,
                      color: Colors.white,
                      size: 45,
                    ),
                  );
                },
              ),

              Container(
                decoration: BoxDecoration(
                  gradient:
                      LinearGradient(
                    begin:
                        Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(
                        alpha: 0.7,
                      ),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),

              Positioned(
                left: 13,
                right: 13,
                bottom: 13,
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style:
                          const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      subtitle,
                      style:
                          const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // SECTION HEADER
  // ==========================================================

  Widget _sectionHeader({
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: darkBlue,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),

        if (onTap != null)
          GestureDetector(
            onTap: onTap,
            child: const Text(
              'View all',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: primaryBlue,
              ),
            ),
          ),
      ],
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
    return Material(
      color: Colors.white,
      borderRadius:
          BorderRadius.circular(19),
      child: InkWell(
        onTap: onTap,
        borderRadius:
            BorderRadius.circular(19),
        child: Container(
          padding:
              const EdgeInsets.all(13),
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(19),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.055,
                ),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Container(
                width: 51,
                height: 51,
                decoration: BoxDecoration(
                  gradient:
                      const LinearGradient(
                    colors: [
                      Color(0xFFE3F2FD),
                      Color(0xFFD4ECFF),
                    ],
                  ),
                  borderRadius:
                      BorderRadius.circular(15),
                ),
                child: Icon(
                  icon,
                  color: primaryBlue,
                  size: 28,
                ),
              ),

              const SizedBox(height: 9),

              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow:
                    TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight:
                      FontWeight.bold,
                  color: darkBlue,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                subtitle,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow:
                    TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
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
    return Material(
      color: Colors.white,
      borderRadius:
          BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius:
            BorderRadius.circular(18),
        child: Container(
          height: 92,
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFE0EAF3),
            ),
          ),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: lightBlue,
                  borderRadius:
                      BorderRadius.circular(13),
                ),
                child: Icon(
                  icon,
                  color: primaryBlue,
                  size: 25,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: darkBlue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// MESSAGE HELPER
// ============================================================

void showMessage(
  BuildContext context,
  String message,
) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      behavior:
          SnackBarBehavior.floating,
      duration:
          const Duration(seconds: 2),
    ),
  );
}