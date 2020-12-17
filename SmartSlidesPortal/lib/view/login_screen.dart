import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:web/view/home_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../helper.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Visibility(
            visible: !isMobile(context),
            child: Expanded(
              child: Container(
                color: Color(0xff6C63FF).withOpacity(0.5),
                child: Stack(
                  children: [
                    kIsWeb
                        ? Image.network(
                            "assets/login_illus.svg",
                          )
                        : SvgPicture.asset("assets/login_illus.svg"),
                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome to\nSmartSlides".toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              letterSpacing: 3,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          Text(
                            "Join to get SmartSlides for your class"
                                .toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w200,
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
          ResponsiveWrapper(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                
                shrinkWrap: true,
                children: [

                  Visibility(
                    visible: isMobile(context),

                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Row(
                          children: [
                            Expanded(child: Container()),
                            Text("Already Have An Account"),
                            Icon(Icons.arrow_forward_ios_outlined)
                          ],
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: Text(
                            "Welcome to \nSmartSlides",
                            style: TextStyle(color: primaryColor, fontSize: 34),
                          ),
                        ),
                        ResponsiveWrapper(
                          maxWidth: 300,
                          minWidth: 150,
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: kIsWeb
                                ? Image.network(
                                    'assets/login_illus.svg',
                                  )
                                : SvgPicture.asset('assets/login_illus.svg'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ResponsiveWrapper(
                    maxWidth: 150,
                    child: LiteRollingSwitch(
                      value: true,
                      textOn: 'Teacher',
                      textOff: 'Student',
                      colorOn: Color(0xff6C63FF),
                      colorOff: Colors.blue,
                      iconOn: Icons.school_outlined,
                      iconOff: Icons.book_online_outlined,
                      textSize: 13.0,
                      onChanged: (bool state) {
                        //Use it to manage the different states
                        print('Current State of SWITCH IS: $state');
                      },
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    child: TextFormField(
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(24.0),
                          prefixIcon: Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                              // width: 0.0 produces a thin "hairline" border
                              borderRadius:
                                  BorderRadius.all(Radius.circular(90.0)),
                              borderSide: BorderSide(color: Colors.white24)
                              //borderSide: const BorderSide(),
                              ),
                          hintStyle: TextStyle(
                              color: Colors.black26,
                              fontFamily: "WorkSansLight"),
                          hintText: 'University Email'),
                    ),
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(24.0),
                        prefixIcon: Icon(Icons.lock_outline),
                        border: OutlineInputBorder(
                            // width: 0.0 produces a thin "hairline" border
                            borderRadius:
                                BorderRadius.all(Radius.circular(90.0)),
                            borderSide: BorderSide(color: Colors.white24)
                            //borderSide: const BorderSide(),
                            ),
                        hintStyle: TextStyle(
                            color: Colors.black26, fontFamily: "WorkSansLight"),
                        hintText: 'Password'),
                  ),
                  SizedBox(height: 30),
                  GFButton(
                    fullWidthButton: true,
                    onPressed: () {
                      Get.to(HomeScreen());
                    },
                    text: "LOGIN",
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      letterSpacing: 3,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: GFButtonShape.pills,
                  ),
                ],
              ),
            ),
            maxWidth: isMobile(context) ? 500 : 375,
            minWidth: 200,
          ),
        ],
      ),
    );
  }
}
