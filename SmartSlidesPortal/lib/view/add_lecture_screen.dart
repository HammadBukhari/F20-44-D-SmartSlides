
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/route_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_framework/responsive_framework.dart';

import '../Controller/LectureProvider.dart';
import '../Controller/PortalProvider.dart';
import '../helper.dart';
import 'home_screen.dart';

class AddLectureScreen extends StatefulWidget {
  final String portalId;

  AddLectureScreen({Key key, @required this.portalId}) : super(key: key);

  @override
  _AddLectureScreenState createState() => _AddLectureScreenState();
}

class _AddLectureScreenState extends State<AddLectureScreen> {
  final provider = GetIt.I<PortalProvider>();

  final borderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(90.0)),
      borderSide: BorderSide(color: Colors.white24));

  final titleController = TextEditingController();

  final descController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  PlatformFile smartSlides;

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
                final lectureId = await GetIt.instance<LectureProvider>()
                    .createLectureInPortal(widget.portalId,
                        titleController.text, descController.text);
                await uploadSmartSlides(lectureId);
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
                SizedBox(
                  height: 15,
                ),
                Builder(builder: (context) {
                  if (smartSlides != null) {
                    return Icon(Icons.check);
                  }
                  return ElevatedButton(
                      onPressed: () async {
                        var result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['zip'],
                        );
                        if (result != null) {
                          smartSlides = result.files.first;
                          setState(() {});
                        }
                      },
                      child: Text('Select SmartSlides'));
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> uploadSmartSlides(String lectureId) async {
    final url =
        'http://384c26059c9a.ngrok.io/process_slides/?lectureId=$lectureId';
    final res = await http.post(
      Uri.parse(url),
    );

    // var request = http.MultipartRequest('POST', Uri.parse(url));
    // request.fields.putIfAbsent('lectureId', () => lectureId);
    // request.files.add(
    //   http.MultipartFile.fromBytes('smartSlides', smartSlides.bytes,
    //       filename: smartSlides.name,
    //       contentType: MediaType.parse('application/zip')),
    // );
    // var res = await request.send();
    print(res.statusCode);
  }
}
