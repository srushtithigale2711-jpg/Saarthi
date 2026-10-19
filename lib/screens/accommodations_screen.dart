
import 'package:flutter/material.dart';

class AccommodationsScreen extends StatefulWidget {
  const AccommodationsScreen({super.key});

  @override
  State<AccommodationsScreen> createState() =>
      _AccommodationsScreenState();
}

class _AccommodationsScreenState
    extends State<AccommodationsScreen> {
  static const Color primaryBlue = Color(0xFF1565C0);
  static const Color deepBlue = Color(0xFF0D47A1);
  static const Color darkBlue = Color(0xFF123B65);
  static const Color background = Color(0xFFF1F7FD);

  final TextEditingController searchController =
      TextEditingController();

  String selectedCategory = 'All';
  String searchText = '';

  final List<Map<String, dynamic>> accommodations = [
    {
      'name': 'Luxury Beach Resort',
      'location': 'Goa, India',
      'price': '₹4,500',
      'rating': '4.8',
      'category': 'Resorts',
      'image':
          'https://images.unsplash.com/photo-1571896349842-33c89424de2d?auto=format&fit=crop&w=1000&q=85',
      'description':
          'Enjoy a relaxing resort stay with beautiful surroundings and comfortable rooms.',
    },
    {
      'name': 'Mountain View Retreat',
      'location': 'Manali, Himachal Pradesh',
      'price': '₹3,200',
      'rating': '4.7',
      'category': 'Hotels',
      'image':
          'https://images.unsplash.com/photo-1518732714860-b62714ce0c59?auto=format&fit=crop&w=1000&q=85',
      'description':
          'A peaceful mountain getaway for nature lovers and adventure travellers.',
    },
    {
      'name': 'Elegant City Hotel',
      'location': 'Mumbai, Maharashtra',
      'price': '₹2,800',
      'rating': '4.5',
      'category': 'Hotels',
      'image':
          'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=85',
      'description':
          'A comfortable city stay suitable for sightseeing and business travel.',
    },
    {
      'name': 'Nature Cottage',
      'location': 'Kerala, India',
      'price': '₹2,400',
      'rating': '4.6',
      'category': 'Homestays',
      'image':
          'https://images.unsplash.com/photo-1449158743715-0a90ebb6d2d8?auto=format&fit=crop&w=1000&q=85',
      'description':
          'A cosy cottage experience surrounded by greenery and natural beauty.',
    },
    {
      'name': 'Royal Heritage Stay',
      'location': 'Jaipur, Rajasthan',
      'price': '₹3,800',
      'rating': '4.9',
      'category': 'Resorts',
      'image':
          'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?auto=format&fit=crop&w=1000&q=85',
      'description':
          'Experience traditional hospitality in a beautiful heritage-inspired setting.',
    },
    {
      'name': 'Budget Traveller Stay',
      'location': 'Pune, Maharashtra',
      'price': '₹900',
      'rating': '4.3',
      'category': 'Budget',
      'image':
          'https://images.unsplash.com/photo-1555854877-bab0e564b8d5?auto=format&fit=crop&w=1000&q=85',
      'description':
          'A simple and affordable accommodation option for budget-conscious travellers.',
    },
  ];

  final List<Map<String, dynamic>> categories = [
    {'name': 'All', 'icon': Icons.grid_view_rounded},
    {'name': 'Hotels', 'icon': Icons.hotel_rounded},
    {'name': 'Resorts', 'icon': Icons.pool_rounded},
    {'name': 'Homestays', 'icon': Icons.house_rounded},
    {'name': 'Budget', 'icon': Icons.savings_rounded},
  ];

  List<Map<String, dynamic>> get filteredAccommodations {
    return accommodations.where((stay) {
      final matchesCategory = selectedCategory == 'All' ||
          stay['category'] == selectedCategory;

      final query = searchText.toLowerCase().trim();

      final matchesSearch = query.isEmpty ||
          stay['name'].toString().toLowerCase().contains(query) ||
          stay['location'].toString().toLowerCase().contains(query) ||
          stay['category'].toString().toLowerCase().contains(query);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void showStayDetails(Map<String, dynamic> stay) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(26),
            ),
          ),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(26),
                    ),
                    child: Image.network(
                      stay['image'],
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 220,
                        color: const Color(0xFFE3F2FD),
                        child: const Icon(
                          Icons.hotel,
                          size: 65,
                          color: primaryBlue,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stay['name'],
                          style: const TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            color: darkBlue,
                          ),
                        ),
                        const SizedBox(height: 9),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: primaryBlue,
                              size: 19,
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(stay['location']),
                            ),
                            const Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                              size: 20,
                            ),
                            Text(
                              ' ${stay['rating']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Text(
                          stay['description'],
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.6,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 22),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              stay['price'],
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: primaryBlue,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(bottom: 4),
                              child: Text(' / night'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(this.context)
                                  .showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Booking is not connected yet. '
                                    'These are sample listings.',
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryBlue,
                              foregroundColor: Colors.white,
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final stays = filteredAccommodations;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Accommodations',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [deepBlue, primaryBlue, Color(0xFF42A5F5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(26),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Find your perfect stay',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 7),
                  const Text(
                    'Hotels, resorts and stays for your next journey.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 19),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        setState(() {
                          searchText = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search hotel or destination',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: primaryBlue,
                        ),
                        suffixIcon: searchText.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  searchController.clear();
                                  setState(() {
                                    searchText = '';
                                  });
                                },
                                icon: const Icon(Icons.close),
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 44,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: 9),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected =
                      selectedCategory == category['name'];

                  return ChoiceChip(
                    selected: isSelected,
                    showCheckmark: false,
                    avatar: Icon(
                      category['icon'],
                      size: 18,
                      color: isSelected ? Colors.white : primaryBlue,
                    ),
                    label: Text(category['name']),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : darkBlue,
                      fontWeight: FontWeight.w600,
                    ),
                    selectedColor: primaryBlue,
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: isSelected
                          ? primaryBlue
                          : const Color(0xFFD5E5F5),
                    ),
                    onSelected: (_) {
                      setState(() {
                        selectedCategory = category['name'];
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Places to stay',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: darkBlue,
                      ),
                    ),
                  ),
                  Text(
                    '${stays.length} stays',
                    style: const TextStyle(
                      color: primaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: stays.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.search_off_rounded,
                            size: 58,
                            color: primaryBlue,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'No stays found',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: darkBlue,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Try another destination or category.',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      itemCount: stays.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 15),
                      itemBuilder: (context, index) {
                        final stay = stays[index];

                        return Material(
                          color: Colors.white,
                          elevation: 2,
                          shadowColor: primaryBlue.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(20),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: () => showStayDetails(stay),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    Image.network(
                                      stay['image'],
                                      height: 185,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, progress) {
                                        if (progress == null) {
                                          return child;
                                        }
                                        return Container(
                                          height: 185,
                                          color: const Color(0xFFDCEBFA),
                                          child: const Center(
                                            child:
                                                CircularProgressIndicator(
                                              color: primaryBlue,
                                            ),
                                          ),
                                        );
                                      },
                                      errorBuilder: (_, __, ___) =>
                                          Container(
                                        height: 185,
                                        color: const Color(0xFFDCEBFA),
                                        child: const Center(
                                          child: Icon(
                                            Icons.hotel_rounded,
                                            color: primaryBlue,
                                            size: 55,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 12,
                                      left: 12,
                                      child: Container(
                                        padding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 11,
                                          vertical: 7,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          stay['category'],
                                          style: const TextStyle(
                                            color: primaryBlue,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 12,
                                      right: 12,
                                      child: Container(
                                        padding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 9,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.star_rounded,
                                              color: Colors.amber,
                                              size: 18,
                                            ),
                                            const SizedBox(width: 3),
                                            Text(
                                              stay['rating'],
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              stay['name'],
                                              style: const TextStyle(
                                                color: darkBlue,
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 7),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.location_on_outlined,
                                                  color: primaryBlue,
                                                  size: 17,
                                                ),
                                                const SizedBox(width: 4),
                                                Expanded(
                                                  child: Text(
                                                    stay['location'],
                                                    style: TextStyle(
                                                      color: Colors
                                                          .grey.shade700,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            stay['price'],
                                            style: const TextStyle(
                                              color: primaryBlue,
                                              fontSize: 19,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'per night*',
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
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
          ],
        ),
      ),
    );
  }
}
