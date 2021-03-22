import 'dart:convert';

class Lecture {
  String lectureId;
  String portalId;
  int creationTime;
  String title;
  String subtitle;
  String authorId;
  String authorName;
  int slidesCount;
  int durationMin;

  Lecture({
    this.lectureId,
    this.creationTime,
    this.title,
    this.subtitle,
    this.authorId,
    this.authorName,
    this.slidesCount,
    this.durationMin,
    this.portalId,
  });

  Map<String, dynamic> toMap() {
    return {
      'lectureId': lectureId,
      'creationTime': creationTime,
      'title': title,
      'subtitle': subtitle,
      'authorId': authorId,
      'authorName': authorName,
      'slidesCount': slidesCount,
      'durationMin': durationMin,
      'portalId': portalId
    };
  }

  factory Lecture.fromMap(Map<String, dynamic> map) {
    return Lecture(
        lectureId: map['lectureId'],
        creationTime: map['creationTime'],
        title: map['title'],
        subtitle: map['subtitle'],
        authorId: map['authorId'],
        authorName: map['authorName'],
        slidesCount: map['slidesCount'],
        durationMin: map['durationMin'],
        portalId: map['portalId']);
  }

  String toJson() => json.encode(toMap());

  factory Lecture.fromJson(String source) =>
      Lecture.fromMap(json.decode(source));
}
