class User {
  final String name;
  final String age;
  final List nickname;

  User(
      {this.name = 'John',
      this.age = '14',
      this.nickname = const ['Johny', 'Bruh']});

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'] ?? '',
        age = json['age'] ?? '',
        nickname = json['nickname'] ?? [];

  Map<String, dynamic> toJson() => {
        'name': name,
        'age': age,
        'nickname': nickname,
      };
}
