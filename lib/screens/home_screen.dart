import 'package:flutter/material.dart';
import 'package:photodiary/components/main_calendar.dart';
import 'package:photodiary/const/colors.dart';
import 'package:photodiary/pages/auth_page.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  // ➊ StatelessWidget에서 StatefulWidget으로 전환
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.utc(
    // ➋ 선택된 날짜를 관리할 변수
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  File? _photo;
  Map<DateTime, ImageProvider> photosByDatetime = {};
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    initializeDateFormatting();
  }

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile() async {
    if (_photo == null) return;
    final fileName = basename(_photo!.path);
    final destination = 'calendar/$selectedDate';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child(fileName);
      await ref.putFile(_photo!);

      photosByDatetime.addAll({
        selectedDate: Platform.isWindows
            ? Image.network(
                _photo!.path,
                width: 100,
                height: 100,
                fit: BoxFit.fitHeight,
              ).image
            : Image.file(
                _photo!,
                width: 100,
                height: 100,
                fit: BoxFit.fitHeight,
              ).image,
      });
    } catch (e) {
      print('error occured');
    }
  }

  @override
  Widget build(BuildContext context) {
    void onDaySelected(DateTime selectedDate, DateTime focusedDate) {
      // ➌ 날짜 선택될 때마다 실행할 함수
      setState(() {
        this.selectedDate = selectedDate;
        _showPicker(context);
      });
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        // ➊ 새 일정 버튼
        backgroundColor: primaryColor,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AuthPage()),
          );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
      body: SafeArea(
        // 시스템 UI 피해서 UI 구현하기
        child: Column(
          // 달력과 리스트를 세로로 배치
          children: [
            MainCalendar(
              selectedDate: selectedDate, // 선택된 날짜 전달하기

              // 날짜가 선택됐을 때 실행할 함수
              onDaySelected: onDaySelected,
              photosByDatetime: photosByDatetime,
            ),
          ],
        ),
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  imgFromGallery();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  imgFromCamera();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
