import 'dart:async';
import 'dart:ui' as ui;
import 'package:web/model/User.dart' as app_user;
import 'package:get/get.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum LoginResult {
  inProgress,
  notLoggedIn,
  loginSuccess,
  noUserFound,
  incorrectPassword,
  noInternet,
  emailInUse,
  passwordTooWeak,
  unknownError,
}

enum Role { teacher, student }

class LoginProvider {
  bool get isUserLoggedIn {
    return _user != null;
  }

  void signOut() async {
    await auth.signOut();
    _setUser(null);
  }

  ValueNotifier<User> userStream;
  ValueNotifier<LoginResult> loginNotifier =
      ValueNotifier(LoginResult.notLoggedIn);
  User _user;

  LoginProvider({User user}) {
    _user = user;
    userStream = ValueNotifier(user);
  }

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<bool> checkMailRegistered(String email, {bool emitMessages}) async {
    print('checkMailRegister accessed');
    final users =
        (await FirebaseAuth.instance.fetchSignInMethodsForEmail(email));
    return users.isNotEmpty;
  }

  Future<void> loginWithEmail(String email, String password) async {
    loginNotifier.value = LoginResult.inProgress;
    try {
      final result = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (result.user != null) {
        _setUser(result.user);
        await Fluttertoast.showToast(
            msg: 'Sign in success',
            backgroundColor: Colors.white,
            textColor: Colors.black,
            toastLength: Toast.LENGTH_LONG);
        loginNotifier.value = LoginResult.loginSuccess;
      }
    } on FirebaseAuthException catch (exception) {
      loginNotifier.value = LoginResult.unknownError;
      // ignore: unawaited_futures
      Get.showSnackbar(GetBar(
        title: 'An error occurred while logging in',
        message: exception.message,
        duration: Duration(seconds: 5),
      ));
      return;
    }
  }

  Future<void> registerWithEmail(
      String name, String email, String password, ui.Image image) async {
    loginNotifier.value = LoginResult.inProgress;

    UserCredential authResult;
    try {
      authResult = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _setUser(authResult.user);

      // set data of {user}

      // String imageUrl;
      // if (image != null) {
      //   imageUrl = await uploadUserImage(image);
      // }

      await updateUserName(name, null);

      await storeUserInFirestore();
      if (!_user.emailVerified) {
        await _user.sendEmailVerification();
      }

      await Fluttertoast.showToast(msg: 'Registration success');
      loginNotifier.value = LoginResult.loginSuccess;
    } on FirebaseAuthException catch (exception) {
      loginNotifier.value = LoginResult.unknownError;
      // ignore: unawaited_futures
      Get.showSnackbar(GetBar(
        title: 'An error occured while registering',
        message: exception.message,
        duration: Duration(seconds: 5),
      ));
      return;
    }
  }

  void _setUser(User user) {
    _user = user;
    userStream.value = user;
  }

  // Future<String> uploadUserImage(ui.Image toUpload) async {
  //   var byteData = await toUpload.toByteData(format: ui.ImageByteFormat.png);
  //   var buffer = byteData.buffer.asUint8List();
  //   // final fileToUpload = File.fromRawPath(buffer);

  //   // compress image
  //   // img.Image image = img.decodeImage(buffer);
  //   // img.Image thumbnail = img.copyResize(image, width: 500);
  //   Directory tempDir = await getTemporaryDirectory();
  //   String tempPath = tempDir.path;
  //   String tempFilePath = path.join(tempPath, "temp.png");
  //   final fileToUpload = File(tempFilePath)..writeAsBytesSync(buffer);

  //   final storage = FirebaseStorage.instance;
  //   // final StorageMetadata metaData = StorageMetadata()
  //   final snapshot = await storage
  //       .ref()
  //       .child("user/profile_picture/${_user.uid}.png")
  //       .putFile(fileToUpload)
  //       .onComplete;
  //   return await snapshot.ref.getDownloadURL();
  // }

  Future<void> updateUserName(String name, String imageUrl,
      {String password}) async {
    // if (name == null && imageUrl == null && password == null) return null;
    if (name != null) await _user?.updateProfile(displayName: name);
    if (imageUrl != null) await _user?.updateProfile(photoURL: imageUrl);

    await _user?.reload();
    _setUser(auth.currentUser);
  }

  Future<void> storeUserInFirestore({bool isUpdate = false}) async {
    if (!isUpdate) {
      final userDocs = await FirebaseFirestore.instance
          .collection('user')
          .where('uid', isEqualTo: _user.uid)
          .get();
      //already saved user
      if (userDocs.docs.isNotEmpty) return;
    }
    final dataToUpload = {
      'uid': _user.uid,
      'name': _user.displayName,
      'email': _user.email,
    };

    // if (_user.photoURL != null) {
    //   dataToUpload.putIfAbsent("photoUrl", () => _user.photoURL);
    //   final photoBytes = (await get(_user.photoURL)).bodyBytes;
    //   var blurHash = await BlurHash.encode(photoBytes, 4, 3);
    //   dataToUpload.putIfAbsent("photoBlurHash", () => blurHash);
    // }
    await FirebaseFirestore.instance
        .collection('user')
        .doc(
          _user.uid,
        )
        .set(dataToUpload);
  }

  // Future<File> pickImageForRegistration() async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.getImage(
  //       source: ImageSource.gallery,
  //       imageQuality: 70,
  //       maxHeight: 1000,
  //       maxWidth: 1000);
  //   if (pickedFile != null) return File(pickedFile.path);
  //   return null;
  // }

  // Future<FirestoreUser> getFirestoreUserFromEmail(String email) async {
  //   final docs = (await (FirebaseFirestore.instance
  //           .collection("user")
  //           .where("email", isEqualTo: email)
  //           .get()))
  //       .docs;
  //   if (docs[0] != null) return FirestoreUser.fromMap(docs[0].data());
  //   return null;
  // }

  app_user.User getLoggedInUser() {
    return app_user.User(
        email: _user.email, name: _user.displayName, uid: _user.uid);
  }

  Future<void> updatePassword(String password) async {
    if (password != null) {
      try {
        await _user.updatePassword(password);
        _setUser(null);
        await Fluttertoast.showToast(
            msg: 'Password updated. Please sign in again',
            backgroundColor: Colors.white,
            textColor: Colors.black,
            toastLength: Toast.LENGTH_LONG);
      } catch (e) {
        await Fluttertoast.showToast(
            msg: e.toString(),
            backgroundColor: Colors.white,
            textColor: Colors.black,
            toastLength: Toast.LENGTH_LONG);
      }
    }
  }

  // Future<void> updateUserProfile({String name, ui.Image image}) async {
  //   String imageUrl;
  //   if (image != null) {
  //     imageUrl = await uploadUserImage(image);
  //   }

  //   await updateUserName(
  //     name,
  //     imageUrl,
  //   );
  //   await storeUserInFirestore(isUpdate: true);
  //   Fluttertoast.showToast(
  //       msg: "Profile updated",
  //       backgroundColor: Colors.white,
  //       textColor: Colors.black,
  //       toastLength: Toast.LENGTH_LONG);
  // }

  void sendResetPasswordEmail(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } on PlatformException catch (e) {
      await Fluttertoast.showToast(
          msg: e.message,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          toastLength: Toast.LENGTH_LONG);
    }
  }
}
