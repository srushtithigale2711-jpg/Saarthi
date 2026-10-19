import 'package:flutter/material.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({super.key});

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  static const Color primaryBlue = Color(0xFF1565C0);
  static const Color deepBlue = Color(0xFF0D47A1);
  static const Color darkBlue = Color(0xFF123B65);
  static const Color pageBackground = Color(0xFFF1F7FD);

  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _selectedDestination = 'All destinations';

  static const List<String> _categories = [
    'All', 'Street Food', 'Traditional', 'Vegetarian', 'Desserts', 'Restaurants'
  ];

  static const List<Map<String, dynamic>> _foods = [
    {
      'name': 'Misal Pav', 'destination': 'Pune', 'category': 'Street Food',
      'type': 'Vegetarian', 'price': '₹80–₹160', 'description': 'Spicy sprouted-matki curry served with pav, farsan and onion.',
      'image': 'assets/images/food/misal_pav.jpg',
      'icon': Icons.local_fire_department_rounded,
    },
    {
      'name': 'Goan Fish Curry', 'destination': 'Goa', 'category': 'Traditional',
      'type': 'Non-vegetarian', 'price': '₹220–₹450', 'description': 'A coastal curry with coconut, spices and a tangy finish.',
      'image': 'assets/images/food/goan_fish_curry.jpg',
      'icon': Icons.set_meal_rounded,
    },
    {
      'name': 'Dal Baati Churma', 'destination': 'Jaipur', 'category': 'Traditional',
      'type': 'Vegetarian', 'price': '₹180–₹350', 'description': 'A beloved Rajasthani combination of baked baati, dal and sweet churma.',
      'image': 'assets/images/food/dal_baati_churma.jpg',
      'icon': Icons.rice_bowl_rounded,
    },
    {
      'name': 'Masala Dosa', 'destination': 'Kerala', 'category': 'Vegetarian',
      'type': 'Vegetarian', 'price': '₹90–₹200', 'description': 'Crisp dosa filled with spiced potato, served with chutneys and sambar.',
      'image': 'assets/images/food/masala_dosa.jpg',
      'icon': Icons.restaurant_rounded,
    },
    {
      'name': 'Idli Sambar', 'destination': 'Kerala', 'category': 'Vegetarian',
      'type': 'Vegetarian', 'price': '₹50–₹120', 'description': 'Soft steamed rice cakes served with warm sambar and coconut chutney.',
      'image': 'assets/images/food/idli_sambar.jpg',
      'icon': Icons.rice_bowl_rounded,
    },
    {
      'name': 'Chole Bhature', 'destination': 'Delhi', 'category': 'Street Food',
      'type': 'Vegetarian', 'price': '₹100–₹220', 'description': 'Fluffy fried bhature paired with a rich, spicy chickpea curry.',
      'image': 'assets/images/food/chole_bhature.jpg',
      'icon': Icons.lunch_dining_rounded,
    },
    {
      'name': 'Ghewar', 'destination': 'Jaipur', 'category': 'Desserts',
      'type': 'Vegetarian', 'price': '₹120–₹300', 'description': 'A honeycomb-like Rajasthani sweet, often topped with rabri.',
      'image': 'assets/images/food/ghewar.jpg',
      'icon': Icons.cake_rounded,
    },
  ];

  static const List<Map<String, String>> _restaurants = [
    {
      'name': 'Local Maharashtrian Kitchen', 'destination': 'Pune',
      'cuisine': 'Maharashtrian • Vegetarian options', 'price': '₹250–₹500 for two',
      'note': 'Look for thalis, bhakri and regional specials.',
      'image': 'assets/images/food/restaurant_interior.jpg',
    },
    {
      'name': 'Coastal Flavours', 'destination': 'Goa',
      'cuisine': 'Goan • Seafood', 'price': '₹500–₹1,000 for two',
      'note': 'Explore seafood curries and local rice plates.',
      'image': 'assets/images/food/restaurant_interior.jpg',
    },
    {
      'name': 'Heritage Rajasthani Dining', 'destination': 'Jaipur',
      'cuisine': 'Rajasthani • North Indian', 'price': '₹400–₹900 for two',
      'note': 'Try dal baati churma and seasonal regional dishes.',
      'image': 'assets/images/food/restaurant_interior.jpg',
    },
    {
      'name': 'South Indian Tiffin House', 'destination': 'Kerala',
      'cuisine': 'South Indian • Vegetarian options', 'price': '₹200–₹450 for two',
      'note': 'A handy idea for dosa, idli, appam and breakfast.',
      'image': 'assets/images/food/restaurant_interior.jpg',
    },
  ];

  List<Map<String, dynamic>> get _filteredFoods {
    final query = _searchController.text.trim().toLowerCase();
    return _foods.where((food) {
      final categoryMatch = _selectedCategory == 'All' ||
          _selectedCategory == 'Restaurants' ||
          food['category'] == _selectedCategory ||
          (_selectedCategory == 'Vegetarian' && food['type'] == 'Vegetarian');
      final destinationMatch = _selectedDestination == 'All destinations' ||
          food['destination'] == _selectedDestination;
      final queryMatch = query.isEmpty ||
          (food['name'] as String).toLowerCase().contains(query) ||
          (food['destination'] as String).toLowerCase().contains(query) ||
          (food['description'] as String).toLowerCase().contains(query);
      return categoryMatch && destinationMatch && queryMatch;
    }).toList();
  }

  List<Map<String, String>> get _filteredRestaurants {
    final query = _searchController.text.trim().toLowerCase();
    return _restaurants.where((restaurant) {
      final destinationMatch = _selectedDestination == 'All destinations' ||
          restaurant['destination'] == _selectedDestination;
      final queryMatch = query.isEmpty ||
          restaurant.values.any((value) => value.toLowerCase().contains(query));
      return destinationMatch && queryMatch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFoodDetails(Map<String, dynamic> food) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
                child: Image.asset(food['image'] as String, height: 220, width: double.infinity, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _imageFallback(height: 220)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 20, 22, 26),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(food['name'] as String, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: darkBlue)),
                  const SizedBox(height: 8),
                  Text('${food['destination']} • ${food['type']}', style: const TextStyle(color: primaryBlue, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Text(food['description'] as String, style: const TextStyle(fontSize: 15, height: 1.5, color: Colors.black87)),
                  const SizedBox(height: 14),
                  Text('Typical price: ${food['price']}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: darkBlue)),
                  const SizedBox(height: 10),
                  const Text('Prices are estimates and can vary by restaurant and location. These are sample recommendations, not live listings.', style: TextStyle(color: Colors.black54, height: 1.4, fontSize: 12)),
                  const SizedBox(height: 18),
                  SizedBox(width: double.infinity, child: ElevatedButton(
                    onPressed: () => Navigator.pop(sheetContext),
                    style: ElevatedButton.styleFrom(backgroundColor: primaryBlue, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
                    child: const Text('Done'),
                  )),
                ]),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  void _showRestaurantDetails(Map<String, String> restaurant) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Container(
        padding: const EdgeInsets.fromLTRB(22, 12, 22, 26),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(26))),
        child: SafeArea(top: false, child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(child: Container(width: 42, height: 4, decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(4)))),
          const SizedBox(height: 20),
          Text(restaurant['name']!, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: darkBlue)),
          const SizedBox(height: 8),
          Text('${restaurant['destination']} • ${restaurant['cuisine']}', style: const TextStyle(color: primaryBlue, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Text(restaurant['note']!, style: const TextStyle(fontSize: 15, height: 1.45)),
          const SizedBox(height: 12),
          Text('Typical price: ${restaurant['price']}', style: const TextStyle(fontWeight: FontWeight.bold, color: darkBlue)),
          const SizedBox(height: 10),
          const Text('This is a sample restaurant category/recommendation, not a verified business listing. Check current opening hours, address and reviews before visiting.', style: TextStyle(color: Colors.black54, fontSize: 12, height: 1.4)),
          const SizedBox(height: 18),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Navigator.pop(sheetContext), style: ElevatedButton.styleFrom(backgroundColor: primaryBlue, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)), child: const Text('Close'))),
        ])),
      ),
    );
  }

  Widget _imageFallback({double height = 130}) => Container(
    height: height, width: double.infinity, color: const Color(0xFFE4EFFB),
    alignment: Alignment.center, child: const Icon(Icons.restaurant_rounded, size: 42, color: primaryBlue),
  );

  Widget _foodCard(Map<String, dynamic> food) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(18),
    child: InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => _showFoodDetails(food),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(18)), child: Stack(children: [
          Image.asset(food['image'] as String, height: 145, width: double.infinity, fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _imageFallback(height: 145)),
          Positioned(left: 9, top: 9, child: Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5), decoration: BoxDecoration(color: Colors.white.withOpacity(0.94), borderRadius: BorderRadius.circular(30)), child: Text(food['destination'] as String, style: const TextStyle(color: darkBlue, fontSize: 11, fontWeight: FontWeight.bold)))),
        ])),
        Padding(padding: const EdgeInsets.fromLTRB(12, 11, 12, 13), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(food['name'] as String, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: darkBlue)),
          const SizedBox(height: 5),
          Text(food['price'] as String, style: const TextStyle(color: primaryBlue, fontWeight: FontWeight.w700, fontSize: 12)),
          const SizedBox(height: 7),
          Text(food['description'] as String, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, height: 1.35, color: Colors.grey.shade700)),
        ])),
      ]),
    ),
  );

  Widget _restaurantCard(Map<String, String> restaurant) => Card(
    elevation: 0,
    color: Colors.white,
    margin: const EdgeInsets.only(bottom: 13),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    clipBehavior: Clip.antiAlias,
    child: InkWell(onTap: () => _showRestaurantDetails(restaurant), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(width: 116, height: 132, child: Image.asset(restaurant['image']!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _imageFallback(height: 132))),
      Expanded(child: Padding(padding: const EdgeInsets.all(13), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(restaurant['name']!, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, color: darkBlue, fontSize: 15)),
        const SizedBox(height: 5),
        Text('${restaurant['destination']} • ${restaurant['cuisine']}', maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
        const SizedBox(height: 9),
        Text(restaurant['price']!, style: const TextStyle(color: primaryBlue, fontWeight: FontWeight.w700, fontSize: 12)),
        const SizedBox(height: 6),
        const Text('View details  ›', style: TextStyle(color: primaryBlue, fontWeight: FontWeight.w600, fontSize: 12)),
      ]))),
    ])),
  );

  @override
  Widget build(BuildContext context) {
    final foods = _filteredFoods;
    final restaurants = _filteredRestaurants;
    return Scaffold(
      backgroundColor: pageBackground,
      appBar: AppBar(
        title: const Text('Food & Restaurants', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: primaryBlue, foregroundColor: Colors.white, elevation: 0,
      ),
      body: ListView(padding: const EdgeInsets.fromLTRB(16, 16, 16, 30), children: [
        Container(
          padding: const EdgeInsets.all(21),
          decoration: BoxDecoration(gradient: const LinearGradient(colors: [deepBlue, primaryBlue, Color(0xFF42A5F5)], begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(24)),
          child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(Icons.ramen_dining_rounded, color: Colors.white, size: 38),
            SizedBox(height: 14),
            Text('Taste every destination', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 7),
            Text('Discover regional favourites, local flavours and places to eat on your journey.', style: TextStyle(color: Colors.white, height: 1.45, fontSize: 14)),
          ]),
        ),
        const SizedBox(height: 17),
        TextField(
          controller: _searchController,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: 'Search dishes, cuisine or destination',
            prefixIcon: const Icon(Icons.search_rounded, color: primaryBlue),
            filled: true, fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
          child: DropdownButtonHideUnderline(child: DropdownButton<String>(
            isExpanded: true, value: _selectedDestination,
            icon: const Icon(Icons.keyboard_arrow_down_rounded, color: primaryBlue),
            items: const ['All destinations', 'Pune', 'Goa', 'Jaipur', 'Kerala', 'Delhi'].map((destination) => DropdownMenuItem(value: destination, child: Text(destination))).toList(),
            onChanged: (value) => setState(() => _selectedDestination = value ?? 'All destinations'),
          )),
        ),
        const SizedBox(height: 20),
        const Text('Explore by category', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: darkBlue)),
        const SizedBox(height: 10),
        SizedBox(height: 42, child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final category = _categories[index];
            final selected = _selectedCategory == category;
            return ChoiceChip(label: Text(category), selected: selected,
              onSelected: (_) => setState(() => _selectedCategory = category),
              selectedColor: primaryBlue, backgroundColor: Colors.white,
              labelStyle: TextStyle(color: selected ? Colors.white : darkBlue, fontWeight: FontWeight.w600),
              side: BorderSide(color: selected ? primaryBlue : const Color(0xFFD9E7F5)),
            );
          },
        )),
        const SizedBox(height: 22),
        Row(children: [const Expanded(child: Text('Popular local dishes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: darkBlue))), Text('${foods.length} found', style: TextStyle(fontSize: 12, color: Colors.grey.shade600))]),
        const SizedBox(height: 12),
        if (foods.isEmpty) const Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Text('No dishes match your search. Try another category or destination.', style: TextStyle(color: Colors.black54)))
        else GridView.builder(
          shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          itemCount: foods.length, gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 420,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.08,
          ),
          itemBuilder: (_, index) => _foodCard(foods[index]),
        ),
        const SizedBox(height: 25),
        Row(children: [const Expanded(child: Text('Places to eat', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: darkBlue))), Text('${restaurants.length} ideas', style: TextStyle(fontSize: 12, color: Colors.grey.shade600))]),
        const SizedBox(height: 12),
        if (restaurants.isEmpty) const Text('No restaurant ideas match this search.', style: TextStyle(color: Colors.black54))
        else ...restaurants.map(_restaurantCard),
        const SizedBox(height: 8),
        Container(padding: const EdgeInsets.all(13), decoration: BoxDecoration(color: const Color(0xFFE4EFFB), borderRadius: BorderRadius.circular(14)), child: const Text('Note: Food cards use images stored locally in the app assets. Dish prices are estimates, and restaurant cards are illustrative recommendations rather than verified live listings. Check current details before travelling.', style: TextStyle(color: darkBlue, fontSize: 12, height: 1.45))),
      ]),
    );
  }
}
