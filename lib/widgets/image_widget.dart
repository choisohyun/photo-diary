import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photodiary/providers/calendar.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({
    super.key,
    required this.d,
  });

  final DateTime d;

  @override
  Widget build(BuildContext context) {
    String day = d.toString();

    return GetBuilder<CalendarController>(builder: (c) {
      return Container(
        decoration: BoxDecoration(
          image: c.photosByDatetime[day] != null
              ? DecorationImage(image: c.photosByDatetime[day] as ImageProvider)
              : null,
        ),
      );
    });
  }
}
