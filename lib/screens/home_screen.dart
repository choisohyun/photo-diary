import 'package:flutter/material.dart';
import 'package:photodiary/components/main_calendar.dart';
import 'package:photodiary/const/colors.dart';
import 'package:photodiary/pages/auth_page.dart';
import 'package:get/get.dart';
import 'package:photodiary/providers/calendar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(CalendarController());

    return const GetMaterialApp(home: Home());
  }
}

class Home extends StatelessWidget {
  const Home({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
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
      body: const SafeArea(
        child: Column(
          children: [
            MainCalendar(),
          ],
        ),
      ),
    );
  }
}
