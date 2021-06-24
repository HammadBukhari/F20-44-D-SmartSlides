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
  Map<String, List<String>> smartSlides;

  Lecture({
    this.lectureId,
    this.portalId,
    this.creationTime,
    this.title,
    this.subtitle,
    this.authorId,
    this.authorName,
    this.slidesCount,
    this.durationMin,
    this.smartSlides,
  });

  Map<String, dynamic> toMap() {
    return {
      'lectureId': lectureId,
      'portalId': portalId,
      'creationTime': creationTime,
      'title': title,
      'subtitle': subtitle,
      'authorId': authorId,
      'authorName': authorName,
      'slidesCount': slidesCount,
      'durationMin': durationMin,
      'smartSlides': smartSlides,
    };
  }

  factory Lecture.fromMap(Map<String, dynamic> map) {
    final smartSlidesMap = map['smartSlides'];
    Map<String, List<String>> slides = {};
    if (smartSlidesMap != null) {
      print(smartSlidesMap.keys);
      for (final key in smartSlidesMap.keys) {
        slides.putIfAbsent(key, () => List<String>.from(smartSlidesMap[key]));
      }
    }

    return Lecture(
        lectureId: map['lectureId'],
        portalId: map['portalId'],
        creationTime: map['creationTime'],
        title: map['title'],
        subtitle: map['subtitle'],
        authorId: map['authorId'],
        authorName: map['authorName'],
        slidesCount: map['slidesCount'],
        durationMin: map['durationMin'],
        smartSlides: map['smartSlides'] == null ? null : slides);
  }

  String toJson() => json.encode(toMap());

  factory Lecture.fromJson(String source) =>
      Lecture.fromMap(json.decode(source));
}
