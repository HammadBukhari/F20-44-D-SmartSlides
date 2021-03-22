import 'dart:convert';

class Portal {
  String portalCode;
  String name;
  String section;
  String ownerUid;
  Map<String, bool> participants;
  Portal({
    this.portalCode,
    this.name,
    this.section,
    this.participants,
    this.ownerUid,
  });

  Map<String, dynamic> toMap() {
    return {
      'portalCode': portalCode,
      'name': name,
      'section': section,
      'participants': participants,
      'ownerUid': ownerUid,
    };
  }

  factory Portal.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Portal(
      portalCode: map['portalCode'],
      name: map['name'],
      section: map['section'],
      participants: Map<String, bool>.from(map['participants']),
      ownerUid: map['ownerUid'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Portal.fromJson(String source) => Portal.fromMap(json.decode(source));
}
