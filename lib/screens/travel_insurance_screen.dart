import 'package:flutter/material.dart';

class TravelInsuranceScreen extends StatefulWidget {
  const TravelInsuranceScreen({super.key});

  @override
  State<TravelInsuranceScreen> createState() => _TravelInsuranceScreenState();
}

class _TravelInsuranceScreenState extends State<TravelInsuranceScreen> {
  static const Color primaryBlue = Color(0xFF1976D2);
  static const Color darkBlue = Color(0xFF0D47A1);
  static const Color pageColor = Color(0xFFF2F7FD);

  String tripType = 'Domestic';
  String travellerCount = '1 traveller';
  String duration = '1–7 days';
  bool medicalCover = true;
  bool baggageCover = true;
  bool cancellationCover = false;

  final List<Map<String, dynamic>> plans = const [
    {
      'name': 'Essential Cover',
      'tagline': 'Core travel protection',
      'price': 'From ₹150*',
      'icon': Icons.shield_outlined,
      'features': ['Emergency assistance', 'Medical emergency cover', 'Trip support'],
    },
    {
      'name': 'Smart Traveller',
      'tagline': 'Extra peace of mind',
      'price': 'From ₹300*',
      'icon': Icons.health_and_safety_outlined,
      'features': ['Medical emergency cover', 'Baggage delay/loss cover', '24/7 assistance'],
    },
    {
      'name': 'Complete Journey',
      'tagline': 'Broader trip protection',
      'price': 'From ₹500*',
      'icon': Icons.flight_takeoff,
      'features': ['Medical emergency cover', 'Trip cancellation/interruption', 'Baggage protection'],
    },
  ];

  void showPlanDetails(Map<String, dynamic> plan) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.fromLTRB(22, 12, 22, 28),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 42, height: 4, decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(10)))),
              const SizedBox(height: 20),
              Text(plan['name'] as String, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: darkBlue)),
              const SizedBox(height: 6),
              Text(plan['tagline'] as String, style: TextStyle(color: Colors.grey.shade700)),
              const SizedBox(height: 12),
              Text(plan['price'] as String, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: primaryBlue)),
              const SizedBox(height: 16),
              const Text('Coverage highlights', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              ...(plan['features'] as List<String>).map((feature) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(children: [const Icon(Icons.check_circle, color: Colors.green, size: 20), const SizedBox(width: 9), Expanded(child: Text(feature))]),
                  )),
              const SizedBox(height: 16),
              const Text('This is an illustrative sample, not an insurance quote or policy. Actual premiums, exclusions, eligibility and benefits depend on the insurer and policy wording.', style: TextStyle(fontSize: 12, color: Colors.black54, height: 1.4)),
              const SizedBox(height: 18),
              SizedBox(width: double.infinity, child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: primaryBlue, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(this.context).showSnackBar(const SnackBar(content: Text('Live insurer quotes and policy purchase are not connected yet.')));
                },
                icon: const Icon(Icons.open_in_new),
                label: const Text('Explore policy options'),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget choiceChip(String label, bool selected, VoidCallback onTap) => Padding(
        padding: const EdgeInsets.only(right: 8),
        child: ChoiceChip(
          label: Text(label), selected: selected, onSelected: (_) => onTap(),
          selectedColor: primaryBlue,
          labelStyle: TextStyle(color: selected ? Colors.white : darkBlue, fontWeight: FontWeight.w600),
          side: BorderSide(color: selected ? primaryBlue : const Color(0xFFD5E4F6)),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageColor,
      appBar: AppBar(
        title: const Text('Travel Insurance', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          final wide = constraints.maxWidth >= 760;
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: wide ? 28 : 16, vertical: 18),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [primaryBlue, darkBlue], begin: Alignment.topLeft, end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(children: [
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('Travel with confidence', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 9),
                        Text('Explore cover types and compare what matters before your journey.', style: TextStyle(color: Colors.white.withValues(alpha: 0.92), height: 1.4)),
                        const SizedBox(height: 14),
                        const Row(children: [Icon(Icons.verified_user_outlined, color: Colors.white, size: 18), SizedBox(width: 7), Flexible(child: Text('Understand your cover before you buy', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)))]),
                      ])),
                      const SizedBox(width: 12),
                      const Icon(Icons.luggage_outlined, color: Colors.white, size: 66),
                    ]),
                  ),
                  const SizedBox(height: 22),
                  const Text('Personalise your trip', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: darkBlue)),
                  const SizedBox(height: 12),
                  _sectionCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Where are you travelling?', style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Wrap(children: [choiceChip('Domestic', tripType == 'Domestic', () => setState(() => tripType = 'Domestic')), choiceChip('International', tripType == 'International', () => setState(() => tripType = 'International'))]),
                    const SizedBox(height: 12),
                    const Text('Number of travellers', style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Wrap(children: [for (final value in ['1 traveller', '2 travellers', 'Family']) choiceChip(value, travellerCount == value, () => setState(() => travellerCount = value))]),
                    const SizedBox(height: 12),
                    const Text('Trip duration', style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Wrap(children: [for (final value in ['1–7 days', '8–15 days', '16+ days']) choiceChip(value, duration == value, () => setState(() => duration = value))]),
                  ])),
                  const SizedBox(height: 22),
                  const Text('Choose the protection you need', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: darkBlue)),
                  const SizedBox(height: 5),
                  Text('Select cover areas to learn what to look for in a policy.', style: TextStyle(color: Colors.grey.shade700)),
                  const SizedBox(height: 12),
                  _sectionCard(child: Column(children: [
                    _coverToggle(Icons.medical_services_outlined, 'Emergency medical expenses', 'Medical care and emergency assistance abroad or during a trip.', medicalCover, (v) => setState(() => medicalCover = v)),
                    const Divider(height: 20),
                    _coverToggle(Icons.luggage_outlined, 'Baggage protection', 'Check limits for lost, damaged or delayed baggage.', baggageCover, (v) => setState(() => baggageCover = v)),
                    const Divider(height: 20),
                    _coverToggle(Icons.event_busy_outlined, 'Trip cancellation/interruption', 'Review covered reasons, documentation and exclusions.', cancellationCover, (v) => setState(() => cancellationCover = v)),
                  ])),
                  const SizedBox(height: 24),
                  const Text('Explore sample cover levels', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: darkBlue)),
                  const SizedBox(height: 5),
                  const Text('These are illustrative examples, not real insurer products or quotes.', style: TextStyle(color: Colors.black54)),
                  const SizedBox(height: 14),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: plans.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: wide ? 3 : 1, crossAxisSpacing: 14, mainAxisSpacing: 14, mainAxisExtent: 225),
                    itemBuilder: (context, index) {
                      final plan = plans[index];
                      return InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => showPlanDetails(plan),
                        child: Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFDCE8F6)), boxShadow: [BoxShadow(color: darkBlue.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 5))]), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Container(padding: const EdgeInsets.all(11), decoration: BoxDecoration(color: const Color(0xFFE7F0FC), borderRadius: BorderRadius.circular(14)), child: Icon(plan['icon'] as IconData, color: primaryBlue, size: 27)),
                          const SizedBox(height: 12),
                          Text(plan['name'] as String, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkBlue)),
                          const SizedBox(height: 4),
                          Text(plan['tagline'] as String, style: TextStyle(color: Colors.grey.shade700)),
                          const Spacer(),
                          Text(plan['price'] as String, style: const TextStyle(color: primaryBlue, fontSize: 17, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          const Row(children: [Text('View details', style: TextStyle(color: darkBlue, fontWeight: FontWeight.w700)), SizedBox(width: 5), Icon(Icons.arrow_forward, color: primaryBlue, size: 18)]),
                        ])),
                      );
                    },
                  ),
                  const SizedBox(height: 22),
                  Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: const Color(0xFFFFF4D9), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFF0D99D))), child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.info_outline, color: Color(0xFF8A6200)), SizedBox(width: 10), Expanded(child: Text('Before purchasing, check the policy wording, coverage limits, deductibles, pre-existing-condition rules, exclusions, claim process and emergency contact details. Prices shown here are placeholders and do not represent an actual quote.', style: TextStyle(height: 1.45, color: Color(0xFF604A12))))])),
                  const SizedBox(height: 18),
                  Text('Trip selection: $tripType • $travellerCount • $duration', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  Text('Selected cover: ${[if (medicalCover) 'Medical', if (baggageCover) 'Baggage', if (cancellationCover) 'Cancellation'].join(', ')}', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                ]),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _sectionCard({required Widget child}) => Container(width: double.infinity, padding: const EdgeInsets.all(17), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFDCE8F6))), child: child);

  Widget _coverToggle(IconData icon, String title, String subtitle, bool value, ValueChanged<bool> onChanged) => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFFE7F0FC), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: primaryBlue)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w700)), const SizedBox(height: 4), Text(subtitle, style: TextStyle(color: Colors.grey.shade700, height: 1.35, fontSize: 13))])),
        Switch(value: value, activeColor: primaryBlue, onChanged: onChanged),
      ]);
}
