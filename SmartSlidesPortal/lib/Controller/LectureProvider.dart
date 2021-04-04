
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';
import 'package:web/model/lecture.dart';

import 'LoginProvider.dart';

class LectureProvider {
  final loginProvider = GetIt.I<LoginProvider>();
  final colLecture = 'lecture';

  Stream<List<Lecture>> getAllLecturesOfPortal(String portalId) {
    return FirebaseFirestore.instance
        .collection(colLecture)
        .where('portalId', isEqualTo: portalId)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => Lecture.fromMap(e.data())).toList());
  }

  Future<bool> createLectureInPortal(
    String portalId,
    String title,
    String description,
  ) async {
    try {
      final currentUser = loginProvider.getLoggedInUser();

      final toUpload = Lecture(
          lectureId: Uuid().v1(),
          authorId: currentUser.uid,
          authorName: currentUser.name,
          creationTime: DateTime.now().millisecondsSinceEpoch,
          durationMin: 60,
          slidesCount: 20,
          subtitle: description,
          portalId: portalId,
          title: title);
      await FirebaseFirestore.instance
          .collection(colLecture)
          .doc(toUpload.lectureId)
          .set(toUpload.toMap());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
