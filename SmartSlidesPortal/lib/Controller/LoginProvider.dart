// import 'dart:async';
// import 'dart:io';
// import 'dart:ui' as ui;

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get_it/get_it.dart';
// import 'package:http/http.dart';
// // import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart' as path;
// // import 'package:path_provider/path_provider.dart';

// enum LoginResult {
//   inProgress,
//   notLoggedIn,
//   loginSuccess,
//   noUserFound,
//   incorrectPassword,
//   noInternet,
//   emailInUse,
//   passwordTooWeak,
//   unknowError,
// }

// class LoginProvider {
//   bool get isUserLoggedIn {
//     return _user != null;
//   }

//   void signOut() async {
//     await auth.signOut();
//     _setUser(null);
//   }

//   ValueNotifier<User>? userStream;
//   ValueNotifier<LoginResult> loginNotifier =
//       ValueNotifier(LoginResult.notLoggedIn);
//   User? _user;

//   LoginProvider({User? user}) {
//     this._user = user;
//     userStream = ValueNotifier(user!);
//   }

//   FirebaseAuth auth = FirebaseAuth.instance;

//   Future<bool> checkMailRegistered(String email, {bool? emitMessages}) async {
//     print("checkMailRegisted accessed");
//     bool result;
//     final users =
//         (await FirebaseAuth.instance.fetchSignInMethodsForEmail(email));
//     return users.length > 0;
//   }

//   Future<void> loginWithEmail(String email, String password) async {
//     loginNotifier.value = LoginResult.inProgress;
//     try {
//       UserCredential result = await auth.signInWithEmailAndPassword(
//           email: email, password: password);
//       if (result.user != null) {
//         _setUser(result.user);
//         Fluttertoast.showToast(
//             msg: "Sign in success",
//             backgroundColor: Colors.white,
//             textColor: Colors.black,
//             toastLength: Toast.LENGTH_LONG);
//         loginNotifier.value = LoginResult.loginSuccess;
//       }
//     } on PlatformException catch (exception) {
//       if (exception.code == "ERROR_USER_NOT_FOUND") {
//         loginNotifier.value = LoginResult.noUserFound;
//         Fluttertoast.showToast(
//             msg: "No user found against provided email",
//             backgroundColor: Colors.white,
//             textColor: Colors.black,
//             toastLength: Toast.LENGTH_LONG);
//       } else if (exception.code == "ERROR_WRONG_PASSWORD") {
//         Fluttertoast.showToast(
//             msg: "Incorrect password",
//             gravity: ToastGravity.CENTER,
//             backgroundColor: Colors.white,
//             textColor: Colors.black,
//             toastLength: Toast.LENGTH_LONG);
//         loginNotifier.value = LoginResult.incorrectPassword;
//       }
//     }
//   }

//   Future<void> registerWithEmail(
//       String name, String email, String password, ui.Image image) async {
//     loginNotifier.value = LoginResult.inProgress;
//     Fluttertoast.showToast(
//         msg: "Registering. Please wait...",
//         backgroundColor: Colors.white,
//         textColor: Colors.black,
//         toastLength: Toast.LENGTH_LONG);
//     UserCredential authResult;
//     try {
//       authResult = await auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       _setUser(authResult.user);

//       // set data of {user}

//       // String imageUrl;
//       // if (image != null) {
//       //   imageUrl = await uploadUserImage(image);
//       // }

//       await updateUserName(name, null);

//       await storeUserInFirestore();
//       if (!_user!.emailVerified) {
//         _user!.sendEmailVerification();
//       }

//       Fluttertoast.showToast(msg: "Registration success");
//       loginNotifier.value = LoginResult.loginSuccess;
//     } on PlatformException catch (exception) {
//       if (exception.code == "ERROR_EMAIL_ALREADY_IN_USE") {
//         Fluttertoast.showToast(
//             msg: "Email already in use",
//             backgroundColor: Colors.white,
//             textColor: Colors.black,
//             toastLength: Toast.LENGTH_LONG);
//         loginNotifier.value = LoginResult.emailInUse;
//         return;
//       } else if (exception.code == "ERROR_WEAK_PASSWORD") {
//         Fluttertoast.showToast(
//             msg: "Password too weak. Use a combination of letters and numbers",
//             backgroundColor: Colors.white,
//             textColor: Colors.black,
//             toastLength: Toast.LENGTH_LONG);
//         loginNotifier.value = LoginResult.passwordTooWeak;
//         return;
//       }
//     }
//   }

//   void _setUser(User? user) {
//     this._user = user;
//     userStream!.value = user!;
//   }

//   // Future<String> uploadUserImage(ui.Image toUpload) async {
//   //   var byteData = await toUpload.toByteData(format: ui.ImageByteFormat.png);
//   //   var buffer = byteData.buffer.asUint8List();
//   //   // final fileToUpload = File.fromRawPath(buffer);

//   //   // compress image
//   //   // img.Image image = img.decodeImage(buffer);
//   //   // img.Image thumbnail = img.copyResize(image, width: 500);
//   //   Directory tempDir = await getTemporaryDirectory();
//   //   String tempPath = tempDir.path;
//   //   String tempFilePath = path.join(tempPath, "temp.png");
//   //   final fileToUpload = File(tempFilePath)..writeAsBytesSync(buffer);

//   //   final storage = FirebaseStorage.instance;
//   //   // final StorageMetadata metaData = StorageMetadata()
//   //   final snapshot = await storage
//   //       .ref()
//   //       .child("user/profile_picture/${_user.uid}.png")
//   //       .putFile(fileToUpload)
//   //       .onComplete;
//   //   return await snapshot.ref.getDownloadURL();
//   // }

//   Future<void> updateUserName(String? name, String? imageUrl,
//       {String? password}) async {
//     // if (name == null && imageUrl == null && password == null) return null;
//     if (name != null) await _user?.updateProfile(displayName: name);
//     if (imageUrl != null) await _user?.updateProfile(photoURL: imageUrl);

//     await _user?.reload();
//     _setUser(auth.currentUser);
//   }

//   Future<void> storeUserInFirestore({bool isUpdate = false}) async {
//     if (!isUpdate) {
//       final userDocs = await FirebaseFirestore.instance
//           .collection("user")
//           .where("uid", isEqualTo: _user!.uid)
//           .get();
//       //already saved user
//       if (userDocs.docs.length > 0) return;
//     }
//     final Map<String, dynamic> dataToUpload = {
//       "uid": _user!.uid,
//       "name": _user!.displayName,
//       "email": _user!.email,
//       // "games": userGames.map((e) => e.id).toList(),
//     };

//     // if (_user.photoURL != null) {
//     //   dataToUpload.putIfAbsent("photoUrl", () => _user.photoURL);
//     //   final photoBytes = (await get(_user.photoURL)).bodyBytes;
//     //   var blurHash = await BlurHash.encode(photoBytes, 4, 3);
//     //   dataToUpload.putIfAbsent("photoBlurHash", () => blurHash);
//     // }
//     await FirebaseFirestore.instance
//         .collection("user")
//         .doc(
//           _user!.uid,
//         )
//         .set(dataToUpload);
//   }

//   // Future<File> pickImageForRegistration() async {
//   //   final picker = ImagePicker();
//   //   final pickedFile = await picker.getImage(
//   //       source: ImageSource.gallery,
//   //       imageQuality: 70,
//   //       maxHeight: 1000,
//   //       maxWidth: 1000);
//   //   if (pickedFile != null) return File(pickedFile.path);
//   //   return null;
//   // }

//   // Future<FirestoreUser> getFirestoreUserFromEmail(String email) async {
//   //   final docs = (await (FirebaseFirestore.instance
//   //           .collection("user")
//   //           .where("email", isEqualTo: email)
//   //           .get()))
//   //       .docs;
//   //   if (docs[0] != null) return FirestoreUser.fromMap(docs[0].data());
//   //   return null;
//   // }

//   Future<void> updatePassword(String password) async {
//     if (password != null) {
//       try {
//         await _user!.updatePassword(password);
//         _setUser(null);
//         Fluttertoast.showToast(
//             msg: "Password updated. Please sign in again",
//             backgroundColor: Colors.white,
//             textColor: Colors.black,
//             toastLength: Toast.LENGTH_LONG);
//       } catch (e) {
//         Fluttertoast.showToast(
//             msg: e.toString(),
//             backgroundColor: Colors.white,
//             textColor: Colors.black,
//             toastLength: Toast.LENGTH_LONG);
//       }
//     }
//   }

//   // Future<void> updateUserProfile({String name, ui.Image image}) async {
//   //   String imageUrl;
//   //   if (image != null) {
//   //     imageUrl = await uploadUserImage(image);
//   //   }

//   //   await updateUserName(
//   //     name,
//   //     imageUrl,
//   //   );
//   //   await storeUserInFirestore(isUpdate: true);
//   //   Fluttertoast.showToast(
//   //       msg: "Profile updated",
//   //       backgroundColor: Colors.white,
//   //       textColor: Colors.black,
//   //       toastLength: Toast.LENGTH_LONG);
//   // }

//   void sendResetPasswordEmail(String email) async {
//     try {
//       await auth.sendPasswordResetEmail(email: email);
//     } on PlatformException catch (e) {
//       Fluttertoast.showToast(
//           msg: e.message!,
//           backgroundColor: Colors.white,
//           textColor: Colors.black,
//           toastLength: Toast.LENGTH_LONG);
//     }
//   }
// }
