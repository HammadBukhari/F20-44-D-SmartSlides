import 'dart:convert';



class Portal {
  String portalCode;
  String name;
  String section;
  Map<String, bool> particpants;
  Portal({
    this.portalCode,
    this.name,
    this.section,
    this.particpants,
  });

  Map<String, dynamic> toMap() {
    return {
      'portalCode': portalCode,
      'name': name,
      'section': section,
      'particpants': particpants,
    };
  }

  factory Portal.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Portal(
      portalCode: map['portalCode'],
      name: map['name'],
      section: map['section'],
      particpants: Map<String, bool>.from(map['particpants']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Portal.fromJson(String source) => Portal.fromMap(json.decode(source));
}
