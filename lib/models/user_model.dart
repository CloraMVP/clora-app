class AppUser {
  final String name;
  final String email;
  final String? dob;
  final String? phone;
  final String? city;
  final String lastPeriodDate;
  final String medicalHistory;
  final int cycleLength;

  AppUser({
    required this.name,
    required this.email,
    this.dob,
    this.phone,
    this.city,
    required this.lastPeriodDate,
    required this.medicalHistory,
    this.cycleLength = 28,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      dob: map['dob'],
      phone: map['phone'],
      city: map['city'],
      lastPeriodDate: map['lastPeriodDate'] ?? '',
      medicalHistory: map['medicalHistory'] ?? '',
      cycleLength: map['cycleLength'] ?? 28,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'dob': dob,
      'phone': phone,
      'city': city,
      'lastPeriodDate': lastPeriodDate,
      'medicalHistory': medicalHistory,
      'cycleLength': cycleLength,
    };
  }
}
