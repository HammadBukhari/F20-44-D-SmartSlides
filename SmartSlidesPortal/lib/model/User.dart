import 'dart:convert';

class User {
  String uid;
  String name;
  String email;
  List<String> portals;

  User({
    this.uid,
    this.name,
    this.email,
    this.portals,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'portals': portals,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return User(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      portals: map['portals'] != null ? List<String>.from(map['portals']) : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
