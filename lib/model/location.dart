class Location {
  final String strc;
  final String loct;

  Location({required this.strc, required this.loct});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      strc: json['strc'],
      loct: json['loct'],
    );
  }
}