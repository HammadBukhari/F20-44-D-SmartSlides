import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:web/model/User.dart';
import 'package:web/model/lecture.dart';
import 'package:web/model/portal.dart';

import 'LoginProvider.dart';

class PortalProvider {
  final loginProvider = GetIt.I<LoginProvider>();
  List<Portal> portals = [];

  ValueNotifier<bool> newPortalCreated = ValueNotifier(false);
  ValueNotifier<Portal> selectedPortal = ValueNotifier(null);
  ValueNotifier<Lecture> selectedLecture = ValueNotifier(null);
  final portalCol = 'portal';

  PortalProvider() {}
  String _generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  Future<bool> joinPortal(String code) async {
    final currentUser = loginProvider.getLoggedInUser();

    final portalDoc =
        await FirebaseFirestore.instance.collection(portalCol).doc(code).get();
    if (!portalDoc.exists) {
      return false;
    }
    final portal = Portal.fromMap(portalDoc.data());

    await FirebaseFirestore.instance
        .collection('user')
        .doc(currentUser.uid)
        .update({
      'portals': FieldValue.arrayUnion([portal.portalCode]),
    });
    portals.add(portal);
    return true;
  }

  Future<String> createPortal(String name, String section) async {
    final currentUser = loginProvider.getLoggedInUser();

    final classCode = _generateRandomString(6);
    final toCreate = Portal(
        name: name,
        section: section,
        portalCode: classCode,
        ownerUid: currentUser.uid,
        participants: {currentUser.uid: true});
    // add for local use
    portals.add(toCreate);
    await FirebaseFirestore.instance
        .collection(portalCol)
        .doc(classCode)
        .set(toCreate.toMap());
    await FirebaseFirestore.instance
        .collection('user')
        .doc(currentUser.uid)
        .update({
      'portals': FieldValue.arrayUnion([classCode]),
    });
    return classCode;
  }

  Future<void> getAllPortalOfUser() async {
    // get current logged in user
    final currentUser = loginProvider.getLoggedInUser();
    // retrieve portals in which "currentUser" is enrolled/teaching
    final portalsDoc = await FirebaseFirestore.instance
        .collection('user')
        .doc(currentUser.uid)
        .get();
    final portalCodes = User.fromMap(portalsDoc.data()).portals;
    portals = <Portal>[];
    for (final code in portalCodes) {
      final portal = Portal.fromMap(
        (await FirebaseFirestore.instance.collection(portalCol).doc(code).get())
            .data(),
      );
      portals.add(portal);
    }
    selectedPortal.value ??= portals.first;
  }
}
