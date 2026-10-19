import 'package:flutter/material.dart';

class TouristAttractionsScreen extends StatefulWidget {
  const TouristAttractionsScreen({super.key});

  @override
  State<TouristAttractionsScreen> createState() => _TouristAttractionsScreenState();
}

class _TouristAttractionsScreenState extends State<TouristAttractionsScreen> {
  static const Color primaryBlue = Color(0xFF1565C0);
  static const Color deepBlue = Color(0xFF0D47A1);
  static const Color pageBackground = Color(0xFFF1F7FD);

  final TextEditingController _searchController = TextEditingController();
  String _destination = 'All destinations';
  String _category = 'All';

  static const List<String> _destinations = [
    'All destinations', 'Pune', 'Goa', 'Jaipur', 'Kerala', 'Delhi', 'Mumbai'
  ];
  static const List<String> _categories = [
    'All', 'Nature', 'Heritage', 'Adventure', 'Spiritual', 'Family'
  ];

  static const List<Map<String, dynamic>> _places = [
    {
      'name': 'Shaniwar Wada', 'destination': 'Pune', 'category': 'Heritage',
      'tagline': 'Historic fortification in the heart of Pune', 'duration': '1–2 hours',
      'bestTime': 'Morning or late afternoon', 'icon': Icons.account_balance_rounded,
      'image': 'assets/images/attractions/shaniwar_wada.jpg',
      'about': 'Explore the historic Peshwa-era landmark, its grand gateways and gardens. Check current entry arrangements before visiting.'
    },
    {
      'name': 'Fort Aguada', 'destination': 'Goa', 'category': 'Heritage',
      'tagline': 'Portuguese-era fort overlooking the Arabian Sea', 'duration': '1–2 hours',
      'bestTime': 'Early morning or sunset', 'icon': Icons.castle_rounded,
      'image': 'assets/images/attractions/fort_aguada.jpg',
      'about': 'A coastal fort known for sea views, historic walls and scenic photo spots. Wear comfortable shoes and take care near exposed edges.'
    },
    {
      'name': 'Amber Fort', 'destination': 'Jaipur', 'category': 'Heritage',
      'tagline': 'Hilltop palace complex with ornate courtyards', 'duration': '2–3 hours',
      'bestTime': 'Morning', 'icon': Icons.account_balance_rounded,
      'image': 'assets/images/attractions/amber_fort.jpg',
      'about': 'Discover Rajput architecture, courtyards and views across the surrounding hills. Allow extra time for walking around the complex.'
    },
    {
      'name': 'Alleppey Backwaters', 'destination': 'Kerala', 'category': 'Nature',
      'tagline': 'Lush waterways, village scenery and houseboats', 'duration': 'Half day or more',
      'bestTime': 'October to March (typically)', 'icon': Icons.directions_boat_rounded,
      'image': 'assets/images/attractions/alleppey_backwaters.jpg',
      'about': 'Enjoy a relaxed backwater cruise through canals and green landscapes. Confirm boat operator credentials, timings and prices before booking.'
    },
    {
      'name': 'India Gate', 'destination': 'Delhi', 'category': 'Family',
      'tagline': 'Iconic war memorial and open public promenade', 'duration': '45–90 minutes',
      'bestTime': 'Evening', 'icon': Icons.location_city_rounded,
      'image': 'assets/images/attractions/india_gate.jpg',
      'about': 'Visit the landmark and enjoy the surrounding public spaces. Security arrangements and access may change during events.'
    },
    {
      'name': 'Marine Drive', 'destination': 'Mumbai', 'category': 'Nature',
      'tagline': 'Seafront promenade with sweeping city views', 'duration': '1–2 hours',
      'bestTime': 'Sunset or evening', 'icon': Icons.waves_rounded,
      'image': 'assets/images/attractions/marine_drive.jpg',
      'about': 'Walk along the famous curved waterfront and take in the sea breeze and skyline. Follow local safety signs and avoid entering the water.'
    },
    {
      'name': 'Dudhsagar Falls', 'destination': 'Goa', 'category': 'Adventure',
      'tagline': 'Dramatic waterfall amid forested hills', 'duration': 'Half day or more',
      'bestTime': 'Season and access dependent', 'icon': Icons.terrain_rounded,
      'image': 'https://images.unsplash.com/photo-1432405972618-c60b0225b8f9?auto=format&fit=crop&w=1200&q=85',
      'about': 'A spectacular natural attraction. Access can be restricted by season or weather; use authorised routes and check local advisories.'
    },
    {
      'name': 'Dagdusheth Halwai Ganpati Temple', 'destination': 'Pune', 'category': 'Spiritual',
      'tagline': 'Peaceful place for a cultural visit', 'duration': '30–60 minutes',
      'bestTime': 'Check local timings', 'icon': Icons.temple_hindu_rounded,
      'image': 'assets/images/attractions/dagdusheth_ganpati_temple.jpg',
      'about': 'Visit Pune’s famous Ganpati temple, known for its richly decorated shrine and devotional atmosphere. Confirm current darshan timings and photography rules before visiting.'
    },
  ];

  List<Map<String, dynamic>> get _filteredPlaces {
    final q = _searchController.text.trim().toLowerCase();
    return _places.where((p) {
      final matchesDestination = _destination == 'All destinations' || p['destination'] == _destination;
      final matchesCategory = _category == 'All' || p['category'] == _category;
      final matchesSearch = q.isEmpty || ('${p['name']} ${p['destination']} ${p['category']} ${p['tagline']}'.toLowerCase().contains(q));
      return matchesDestination && matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final places = _filteredPlaces;
    return Scaffold(
      backgroundColor: pageBackground,
      appBar: AppBar(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Tourist Attractions', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: const LinearGradient(colors: [primaryBlue, deepBlue], begin: Alignment.topLeft, end: Alignment.bottomRight),
                ),
                child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Icon(Icons.explore_rounded, color: Colors.white, size: 34),
                  SizedBox(height: 10),
                  Text('Find your next favourite place', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(height: 6),
                  Text('Discover iconic landmarks, nature escapes and cultural experiences across India.', style: TextStyle(color: Colors.white, height: 1.4)),
                ]),
              ),
            )),
            SliverToBoxAdapter(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search places, cities or experiences',
                  prefixIcon: const Icon(Icons.search, color: primaryBlue),
                  filled: true, fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            )),
            SliverToBoxAdapter(child: SizedBox(
              height: 48,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 18), scrollDirection: Axis.horizontal,
                itemCount: _destinations.length, separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) => ChoiceChip(
                  label: Text(_destinations[i]), selected: _destination == _destinations[i],
                  selectedColor: primaryBlue, backgroundColor: Colors.white,
                  labelStyle: TextStyle(color: _destination == _destinations[i] ? Colors.white : deepBlue, fontWeight: FontWeight.w600),
                  onSelected: (_) => setState(() => _destination = _destinations[i]),
                ),
              ),
            )),
            SliverToBoxAdapter(child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
              child: Wrap(spacing: 8, runSpacing: 8, children: _categories.map((c) => ChoiceChip(
                label: Text(c), selected: _category == c, selectedColor: const Color(0xFFD4E7FC),
                backgroundColor: Colors.white, labelStyle: const TextStyle(color: deepBlue, fontWeight: FontWeight.w500),
                onSelected: (_) => setState(() => _category = c),
              )).toList()),
            )),
            SliverToBoxAdapter(child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 12),
              child: Row(children: [
                const Expanded(child: Text('Places to explore', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: deepBlue))),
                Text('${places.length} places', style: const TextStyle(color: Colors.black54)),
              ]),
            )),
            if (places.isEmpty)
              const SliverToBoxAdapter(child: Padding(padding: EdgeInsets.all(36), child: Center(child: Text('No attractions found. Try another search or filter.'))))
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 26),
                sliver: SliverLayoutBuilder(builder: (context, constraints) {
                  final width = constraints.crossAxisExtent;
                  final columns = width >= 1050 ? 3 : width >= 650 ? 2 : 1;
                  return SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns, crossAxisSpacing: 14, mainAxisSpacing: 14,
                      mainAxisExtent: columns == 1 ? 340 : 350,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _placeCard(places[index]), childCount: places.length,
                    ),
                  );
                }),
              ),
          ],
        ),
      ),
    );
  }

  Widget _attractionImage(Map<String, dynamic> place, {required double height, double? width}) {
    final path = place['image'] as String;
    final fallback = Container(
      height: height,
      width: width,
      color: const Color(0xFFDCEBFA),
      alignment: Alignment.center,
      child: Icon(place['icon'] as IconData, size: 54, color: primaryBlue),
    );
    if (path.startsWith('assets/')) {
      return Image.asset(path, height: height, width: width, fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => fallback);
    }
    return Image.network(path, height: height, width: width, fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => fallback);
  }

  Widget _placeCard(Map<String, dynamic> place) {
    return Material(
      color: Colors.white, borderRadius: BorderRadius.circular(18), clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showDetails(place),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: 170, width: double.infinity,
            child: Stack(fit: StackFit.expand, children: [
              _attractionImage(place, height: 170),
              Positioned(left: 12, top: 12, child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: Colors.white.withOpacity(.95), borderRadius: BorderRadius.circular(20)),
                child: Text(place['destination'] as String, style: const TextStyle(color: deepBlue, fontWeight: FontWeight.bold, fontSize: 12)),
              )),
            ]),
          ),
          Expanded(child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(place['name'] as String, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: deepBlue)),
              const SizedBox(height: 5),
              Text(place['tagline'] as String, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.black87, height: 1.3)),
              const Spacer(),
              Row(children: [
                Icon(place['icon'] as IconData, size: 17, color: primaryBlue), const SizedBox(width: 5),
                Text(place['category'] as String, style: const TextStyle(color: primaryBlue, fontWeight: FontWeight.w600)),
                const Spacer(), const Text('Details', style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold)),
                const Icon(Icons.chevron_right, color: primaryBlue, size: 20),
              ]),
            ]),
          )),
        ]),
      ),
    );
  }

  void _showDetails(Map<String, dynamic> place) {
    showModalBottomSheet<void>(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (context) => Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * .82),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        child: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(24)), child: _attractionImage(place, height: 220, width: double.infinity)),
          Padding(padding: const EdgeInsets.fromLTRB(20, 18, 20, 24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(place['name'] as String, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: deepBlue)),
            const SizedBox(height: 8),
            Wrap(spacing: 8, children: [
              _detailPill(Icons.location_on_outlined, place['destination'] as String),
              _detailPill(Icons.category_outlined, place['category'] as String),
              _detailPill(Icons.schedule, place['duration'] as String),
            ]),
            const SizedBox(height: 18),
            const Text('About this place', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: deepBlue)),
            const SizedBox(height: 7), Text(place['about'] as String, style: const TextStyle(height: 1.5, fontSize: 15)),
            const SizedBox(height: 16),
            const Text('Suggested time to visit', style: TextStyle(fontWeight: FontWeight.bold, color: deepBlue)),
            const SizedBox(height: 5), Text(place['bestTime'] as String),
            const SizedBox(height: 16),
            const Text('Before you go: Confirm current opening hours, entry fees, weather and local travel guidance. These listings are suggestions, not live-verified visitor information.', style: TextStyle(color: Colors.black54, height: 1.4)),
          ])),
        ])),
      ),
    );
  }

  Widget _detailPill(IconData icon, String text) => Chip(
    avatar: Icon(icon, size: 16, color: primaryBlue), label: Text(text),
    backgroundColor: const Color(0xFFEAF3FD), side: BorderSide.none,
  );
}
