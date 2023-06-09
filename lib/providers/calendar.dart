import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:intl/date_symbol_data_local.dart';
import 'package:path/path.dart';
import 'dart:io';

class CalendarController extends GetxController {
  static CalendarController get to => Get.find();
  Rx<DateTime> selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  ).obs;
  Map<DateTime, ImageProvider> photosByDatetime = {};
  File? _photo;
  final ImagePicker _picker = ImagePicker();

  void onDaySelected(DateTime selected, DateTime focusedDate) {
    selectedDate.value = selected;
  }

  @override
  void onInit() {
    super.onInit();

    initializeDateFormatting();

    ever(selectedDate, (_) {
      showPicker();
    });
  }

  showPicker() {
    Get.bottomSheet(
      SafeArea(
        child: SizedBox(
          height: 120,
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  imgFromGallery();
                  Get.back();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  imgFromCamera();
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _photo = File(pickedFile.path);
      uploadFile();
    } else {
      print('No image selected.');
    }
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      _photo = File(pickedFile.path);
      uploadFile();
    } else {
      print('No image selected.');
    }
  }

  Future uploadFile() async {
    if (_photo == null) return;
    final fileName = basename(_photo!.path);
    final destination = 'calendar/$selectedDate';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child(fileName);
      firebase_storage.UploadTask task = ref.putFile(_photo!);
      String url = await (await task).ref.getDownloadURL();

      print(url);
      photosByDatetime[selectedDate.value] = Image.network(
        url,
        width: 100,
        height: 100,
        fit: BoxFit.fitHeight,
      ).image;
    } catch (e) {
      print('error occured');
    }
  }
}
