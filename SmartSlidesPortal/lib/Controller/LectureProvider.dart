import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';
import 'package:web/model/Response.dart' as QResponse;
import 'package:web/model/lecture.dart';
import 'package:get/get.dart';
import 'package:web/model/question.dart';

import 'LoginProvider.dart';
import 'PortalProvider.dart';

class LectureProvider extends GetxController {
  final loginProvider = GetIt.I<LoginProvider>();
  final portalProvider = GetIt.I<PortalProvider>();

  final colLecture = 'lecture';
  final subColQuestion = 'question';

  final allLecturesOfSelectedPortal = <Lecture>[].obs;

  // var dummyQuestion;

  LectureProvider() {
    // dummyQuestion = Question(
    //     qRaiserId: 'h6GAD3YKaqYgRMYGDg8gZ5CegOV2',
    //     qRaiserName: 'Hammad Ali',
    //     question: 'Test question',
    //     questionRaisingTime: DateTime.now()
    //         .subtract(Duration(minutes: 20))
    //         .millisecondsSinceEpoch,
    //     answers: [
    //       QResponse.Response(
    //           responserId: Uuid().v1(),
    //           responserName: 'Hammad Ali',
    //           responseCreationTime: DateTime.now()
    //               .subtract(Duration(minutes: 10))
    //               .millisecondsSinceEpoch,
    //           response: 'Test response'),
    //       QResponse.Response(
    //           responserId: Uuid().v1(),
    //           responserName: 'Hammad Ali',
    //           responseCreationTime: DateTime.now()
    //               .subtract(Duration(minutes: 5))
    //               .millisecondsSinceEpoch,
    //           response: 'Test response'),
    //       QResponse.Response(
    //           responserId: Uuid().v1(),
    //           responserName: 'Hammad Ali',
    //           responseCreationTime: DateTime.now()
    //               .subtract(Duration(minutes: 3))
    //               .millisecondsSinceEpoch,
    //           response: 'Test response')
    //     ],
    //     lectureId: '4d455b60-9552-11eb-9172-3f78a7b35158',
    //     questionId: Uuid().v1());
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

  Stream<List<Question>> getAllQuestionOfLecture(String lectureId) {
    return FirebaseFirestore.instance
        .collection(colLecture)
        .doc(lectureId)
        .collection(subColQuestion)
        .snapshots()
        .map(
          (querySnap) => querySnap.docs
              .map(
                (e) => Question.fromMap(e.data()),
              )
              .toList(),
        );
  }

  Future<void> addQuestionToLecture(String lectureId, Question question) async {
    await FirebaseFirestore.instance
        .collection(colLecture)
        .doc(lectureId)
        .collection(subColQuestion)
        .doc(question.questionId)
        .set(question.toMap());
  }

  Future<void> addResponseToQuestion(
      String lectureId, String questionId, String responseText) async {
    final appUser = GetIt.I<LoginProvider>().getLoggedInUser();
    final response = QResponse.Response(
      response: responseText,
      responseCreationTime: DateTime.now().millisecondsSinceEpoch,
      responserId: appUser.uid,
      responserName: appUser.name,
    );
    await FirebaseFirestore.instance
        .collection(colLecture)
        .doc(lectureId)
        .collection(subColQuestion)
        .doc(questionId)
        .update({
      'answers': FieldValue.arrayUnion([response.toMap()])
    });
  }
}
