import 'package:flutter/material.dart';
import 'package:photodiary/components/main_calendar.dart';
import 'package:photodiary/const/colors.dart';
import 'package:photodiary/pages/auth_page.dart';
import 'package:get/get.dart';
import 'package:photodiary/providers/calendar.dart';

class HomeScreen extends StatelessWidget {
  // ➊ StatelessWidget에서 StatefulWidget으로 전환
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
      body: SafeArea(
        child: Column(
          children: [
            GetBuilder<CalendarController>(
              builder: (c) {
                return MainCalendar(
                  selectedDate: c.selectedDate.value,
                  onDaySelected: c.onDaySelected,
                  photosByDatetime: c.photosByDatetime,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
