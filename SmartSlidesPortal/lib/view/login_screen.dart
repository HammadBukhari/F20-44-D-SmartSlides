import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:web/Controller/LoginProvider.dart';
import 'package:web/view/home_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../helper.dart';

class LoginScreen extends StatefulWidget {
  final bool onRegistrationMode;
  LoginScreen({this.onRegistrationMode});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final provider = GetIt.I<LoginProvider>();

  final nameController = TextEditingController();

  final emailController = TextEditingController(text: 'i170329@nu.edu.pk');

  final passwordController = TextEditingController(text: 'abc12345');

  final formKey = GlobalKey<FormState>();

  final borderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(90.0)),
      borderSide: BorderSide(color: Colors.white24));

  Role selectedRole = Role.teacher;

  String get illustrationPath {
    return 'assets/login_illus_trans.png';
  }

  bool _isLoadingDialogShowing = false;

  @override
  void initState() {
    provider.loginNotifier.addListener(() {
      final loginResult = provider.loginNotifier.value;
      if (loginResult == LoginResult.loginSuccess) {
        if (_isLoadingDialogShowing) {
          Navigator.of(context).pop();
        }
        _isLoadingDialogShowing = false;
        Get.offAll(HomeScreen());

        // Navigator.pop(context);
      } else if (loginResult == LoginResult.inProgress) {
        if (!_isLoadingDialogShowing) {
          _isLoadingDialogShowing = true;
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: SizedBox(
                  height: 64,
                  width: 64,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            },
          );
        }
      } else {
        if (_isLoadingDialogShowing) {
          Navigator.of(context).pop();
          _isLoadingDialogShowing = false;
        }
      }
    });
    super.initState();
  }

  Widget buildAuthForm(BuildContext context) {
    return Container(
      width: isMobile(context) ? 1.sw : 0.4.sw,
      child: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(16.0),
          children: [
            InkWell(
              onTap: () {
                if (widget.onRegistrationMode) {
                  Get.to(
                    LoginScreen(
                      onRegistrationMode: false,
                    ),
                    transition: Transition.leftToRightWithFade,
                  );
                } else {
                  Get.back();
                }
              },
              child: Row(
                children: [
                  Expanded(child: Container()),
                  Text(widget.onRegistrationMode
                      ? 'Already Have An Account?'
                      : 'Create An Account'),
                  Icon(Icons.arrow_forward_ios_outlined)
                ],
              ),
            ),
            Visibility(
              visible: isMobile(context),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10),
                  Center(
                    child: Text(
                      'Welcome to \nSmartSlides',
                      style: TextStyle(color: GFColors.PRIMARY, fontSize: 34),
                    ),
                  ),
                  ResponsiveWrapper(
                    maxWidth: 300,
                    minWidth: 150,
                    child: Image.asset(
                      illustrationPath,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Visibility(
              visible: widget.onRegistrationMode,
              child: TextFormField(
                controller: nameController,
                validator: RequiredValidator(errorText: 'Name is required'),
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(24.0),
                    prefixIcon: Icon(Icons.supervised_user_circle_outlined),
                    border: borderStyle,
                    hintStyle: TextStyle(
                      color: Colors.black26,
                    ),
                    hintText: 'Name'),
              ),
            ),
            SizedBox(height: 30),
            TextFormField(
              controller: emailController,
              validator: MultiValidator([
                EmailValidator(errorText: 'enter a valid email address'),
                RequiredValidator(errorText: 'Email is required'),
              ]),
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(24.0),
                  prefixIcon: Icon(Icons.email_outlined),
                  border: borderStyle,
                  hintStyle: TextStyle(
                    color: Colors.black26,
                  ),
                  hintText: 'University Email'),
            ),
            SizedBox(height: 30),
            TextFormField(
              validator: MultiValidator([
                RequiredValidator(errorText: 'password is required'),
                MinLengthValidator(8,
                    errorText: 'password must be at least 8 digits long'),
              ]),
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(24.0),
                  prefixIcon: Icon(Icons.lock_outline),
                  border: borderStyle,
                  hintStyle: TextStyle(
                    color: Colors.black26,
                  ),
                  hintText: 'Password'),
            ),
            SizedBox(height: 30),
            Container(
              height: 50,
              child: GFButton(
                fullWidthButton: true,
                onPressed: () {
                  if (formKey.currentState.validate()) {
                    final name = nameController.text.trim();
                    final email = emailController.text.trim();
                    final password = passwordController.text;
                    if (widget.onRegistrationMode) {
                      //register user
                      provider.registerWithEmail(name, email, password, null);
                    } else {
                      // login user
                      provider.loginWithEmail(email, password);
                    }
                  }
                },
                text: widget.onRegistrationMode ? 'Create An Account' : 'Login',
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  letterSpacing: 3,
                  fontWeight: FontWeight.w600,
                ),
                shape: GFButtonShape.pills,
                color: GFColors.PRIMARY,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: !isMobile(context)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Visibility(
                    visible: !isMobile(context),
                    child: Expanded(
                      child: Container(
                        color: Color(0xff6C63FF).withOpacity(0.5),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              illustrationPath,
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Welcome to\nSmartSlides'.toUpperCase(),
                                    style: TextStyle(
                                      shadows: <Shadow>[
                                        Shadow(
                                          offset: Offset(-4.0, 7.0),
                                          blurRadius: 7.0,
                                          color: Color.fromARGB(255, 0, 0, 0),
                                        ),
                                      ],
                                      color: Colors.white,
                                      fontSize: 40,
                                      letterSpacing: 3,
                                      fontWeight: FontWeight.w900,
                                      //backgroundColor: Colors.white60
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(),
                                  ),
                                  Text(
                                    'Join to get SmartSlides for your class'
                                        .toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w200,
                                      //backgroundColor: Colors.white30
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  buildAuthForm(context),
                ],
              )
            : buildAuthForm(context),
      ),
    );
  }
}
