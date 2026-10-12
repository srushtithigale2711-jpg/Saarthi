class Trip {
  final String destination;

  final DateTime startDate;
  final DateTime endDate;

  final int adults;
  final int children;
  final List<int> childrenAges;
  final int infants;

  final double budget;

  final List<String> interests;

  const Trip({
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.adults,
    required this.children,
    required this.childrenAges,
    required this.infants,
    required this.budget,
    required this.interests,
  });

  // ------------------------------------------------------------
  // TRIP DURATION
  // ------------------------------------------------------------

  int get duration {
    return endDate.difference(startDate).inDays;
  }

  // ------------------------------------------------------------
  // TOTAL TRAVELLERS
  // ------------------------------------------------------------

  int get totalTravellers {
    return adults + children + infants;
  }

  // ------------------------------------------------------------
  // COPY WITH
  // ------------------------------------------------------------
  //
  // This will be useful later when the AI modifies/re-optimises
  // the trip.
  //

  Trip copyWith({
    String? destination,
    DateTime? startDate,
    DateTime? endDate,
    int? adults,
    int? children,
    List<int>? childrenAges,
    int? infants,
    double? budget,
    List<String>? interests,
  }) {
    return Trip(
      destination: destination ?? this.destination,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      adults: adults ?? this.adults,
      children: children ?? this.children,
      childrenAges: childrenAges ?? this.childrenAges,
      infants: infants ?? this.infants,
      budget: budget ?? this.budget,
      interests: interests ?? this.interests,
    );
  }

  // ------------------------------------------------------------
  // DEBUG / DISPLAY
  // ------------------------------------------------------------

  @override
  String toString() {
    return '''
Trip(
  destination: $destination,
  startDate: $startDate,
  endDate: $endDate,
  duration: $duration days,
  adults: $adults,
  children: $children,
  childrenAges: $childrenAges,
  infants: $infants,
  totalTravellers: $totalTravellers,
  budget: $budget,
  interests: $interests,
)
''';
  }
}