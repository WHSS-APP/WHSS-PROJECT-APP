class DamageCode {
  final String id;
  final String description;

  DamageCode({required this.id, required this.description});

  factory DamageCode.fromJson(Map<String, dynamic> json) {
    return DamageCode(
      id: json['id'],
      description: json['description'],
    );
  }
}