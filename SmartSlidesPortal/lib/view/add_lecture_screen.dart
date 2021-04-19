import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/route_manager.dart';
// import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:uuid/uuid.dart';
import '../Controller/LectureProvider.dart';
import 'package:path_provider/path_provider.dart';
import '../Controller/LoginProvider.dart';
import '../Controller/PortalProvider.dart';
import '../helper.dart';
import '../model/lecture.dart';
import 'home_screen.dart';
import 'dart:ui' as ui;
import 'package:path/path.dart' as path;
import 'package:dio/dio.dart';

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
                ElevatedButton(
                    onPressed: () async {
                      var result = await FilePicker.platform.pickFiles();
                      if (result != null) {
                        Response response;
                        var dio = Dio(BaseOptions(baseUrl: ''));
                        var formData = FormData.fromMap({
                          'name': 'wendux',
                          'age': 25,
                          'file': await MultipartFile.fromFile('./text.txt',
                              filename: 'upload.txt'),
                          'files': [
                            await MultipartFile.fromFile('./text1.txt',
                                filename: 'text1.txt'),
                            await MultipartFile.fromFile('./text2.txt',
                                filename: 'text2.txt'),
                          ]
                        });

                        response = await dio.post('/info', data: formData);
                      } else {
                        // User canceled the picker
                      }

                      // PdfDocument.openAsset('assets/sample.pdf');
                    },
                    child: Text('test')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



                        // print(result.files.single.path);
                        // final fi = await PdfDocument.openFile(
                        //     result.files.single.path);
                        // final page = await fi.getPage(1);
                        // final pdfImage = await page.render(
                        //     width: page.width, height: page.height);
                        // var buffer = pdfImage.bytes;
                        // Directory tempDir = await getTemporaryDirectory();
                        // String tempPath = tempDir.path;
                        // String tempFilePath = path.join(tempPath, "temp.png");
                        // final fileToUpload = File(tempFilePath)
                        //   ..writeAsBytesSync(buffer);

                        // print(tempFilePath);