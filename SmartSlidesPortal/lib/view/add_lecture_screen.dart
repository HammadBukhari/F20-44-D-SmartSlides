import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:uuid/uuid.dart';
import 'package:web/Controller/LectureProvider.dart';
import 'package:web/Controller/LoginProvider.dart';
import 'package:web/Controller/PortalProvider.dart';
import 'package:web/helper.dart';
import 'package:web/model/lecture.dart';
import 'package:web/view/home_screen.dart';

class AddLectureScreen extends StatelessWidget {
  final String portalId;
  final provider = GetIt.I<PortalProvider>();
  final borderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(90.0)),
      borderSide: BorderSide(color: Colors.white24));

  final titleController = TextEditingController();

  final descController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  AddLectureScreen({Key key, @required this.portalId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Lecture'),
        actions: [
          InkWell(
            onTap: () async {
              if (formKey.currentState.validate()) {
                HelperWidgets.showLoadingDialog();
                await GetIt.instance<LectureProvider>().createLectureInPortal(
                    portalId, titleController.text, descController.text);
                Get.back();
                await Get.offAll(HomeScreen());
                HelperWidgets.showAppSnackbar('Success', 'Lecture Added');
              }
            },
            child: Row(
              children: [
                Icon(Icons.add),
                Text('Upload'),
                SizedBox(
                  width: 10,
                )
              ],
            ),
          ),
        ],
        backgroundColor: GFColors.PRIMARY,
        centerTitle: true,
      ),
      body: Form(
        key: formKey,
        child: Align(
          alignment: Alignment.topCenter,
          child: ResponsiveWrapper(
            maxWidth: 500,
            minWidth: 200,
            child: ListView(
              shrinkWrap: true,
              children: [
                SizedBox(height: 30),
                TextFormField(
                  controller: titleController,
                  validator: RequiredValidator(errorText: 'Title is required'),
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(24.0),
                      prefixIcon: Icon(Icons.title),
                      border: borderStyle,
                      hintStyle: TextStyle(
                        color: Colors.black26,
                      ),
                      hintText: 'Lecture Title'),
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: descController,
                  validator:
                      RequiredValidator(errorText: 'Description is required'),
                  maxLines: 5,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(24.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        borderSide: BorderSide(
                          color: Colors.white24,
                        ),
                      ),
                      hintStyle: TextStyle(
                        color: Colors.black26,
                      ),
                      hintText: 'Lecture Description'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
