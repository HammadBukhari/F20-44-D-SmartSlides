import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';
import 'package:web/model/lecture.dart';
import 'package:get/get.dart';

import 'LoginProvider.dart';
import 'PortalProvider.dart';

class LectureProvider extends GetxController {
  final loginProvider = GetIt.I<LoginProvider>();
  final portalProvider = GetIt.I<PortalProvider>();

  final colLecture = 'lecture';

  final allLecturesOfSelectedPortal = <Lecture>[].obs;

  LectureProvider() {
    init();
  }

  void init() {
    portalProvider.selectedPortal.addListener(portalLectureListener);
  }

  VoidCallback portalLectureListener() {
    if (portalProvider.selectedPortal == null) return null;
    allLecturesOfSelectedPortal.clear();

    getAllLecturesOfPortal(portalProvider.selectedPortal.value.portalCode)
        .then((value) {
      allLecturesOfSelectedPortal.addAll(value);
    });

    return null;
  }

  void updateCurrentLectureList() {
    portalLectureListener();
  }

  Future<List<Lecture>> getAllLecturesOfPortal(String portalId) async {
    final queryResponse = await FirebaseFirestore.instance
        .collection(colLecture)
        .where('portalId', isEqualTo: portalId)
        .get();

    return queryResponse.docs
        .map((event) => Lecture.fromMap(event.data()))
        .toList();
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
      updateCurrentLectureList();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
