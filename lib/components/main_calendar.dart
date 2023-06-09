import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:photodiary/const/colors.dart';

class MainCalendar extends StatelessWidget {
  final OnDaySelected onDaySelected; // ➊ 날짜 선택 시 실행할 함수
  final DateTime selectedDate; // ➋ 선택된 날짜
  final Map<DateTime, ImageProvider>? photosByDatetime;

  const MainCalendar({
    super.key,
    required this.onDaySelected,
    required this.selectedDate,
    this.photosByDatetime,
  });

  imageBuilder(BuildContext context, DateTime day) {
    if (photosByDatetime == null || photosByDatetime?.keys == null) {
      return null;
    }

    for (DateTime d in photosByDatetime!.keys) {
      if (day.day == d.day && day.month == d.month && day.year == d.year) {
        return ImageWidget(photosByDatetime: photosByDatetime, d: d);
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      locale: 'ko_kr',
      onDaySelected: onDaySelected,
      // ➌ 날짜 선택 시 실행할 함수
      selectedDayPredicate: (date) => // ➍ 선택된 날짜를 구분할 로직
          date.year == selectedDate.year &&
          date.month == selectedDate.month &&
          date.day == selectedDate.day,
      firstDay: DateTime(1800, 1, 1), // ➊ 첫째 날
      lastDay: DateTime(3000, 1, 1), // ➋ 마지막 날
      focusedDay: DateTime.now(),
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) =>
            imageBuilder(context, day),
        prioritizedBuilder: (context, day, focusedDay) =>
            imageBuilder(context, day),
        selectedBuilder: (context, day, focusedDay) =>
            imageBuilder(context, day),
      ),
      headerStyle: const HeaderStyle(
        // ➊ 달력 최상단 스타일
        titleCentered: true, // 제목 중앙에 위치하기
        formatButtonVisible: false, // 달력 크기 선택 옵션 없애기
        titleTextStyle: TextStyle(
          // 제목 글꼴
          fontWeight: FontWeight.w700,
          fontSize: 16.0,
        ),
      ),
      calendarStyle: CalendarStyle(
        isTodayHighlighted: false,
        defaultDecoration: BoxDecoration(
          // ➋ 기본 날짜 스타일
          borderRadius: BorderRadius.circular(6.0),
          color: lightGreyColor,
        ),
        weekendDecoration: BoxDecoration(
          // ➌ 주말 날짜 스타일
          borderRadius: BorderRadius.circular(6.0),
          color: lightGreyColor,
        ),
        selectedDecoration: BoxDecoration(
          // ➍ 선택된 날짜 스타일
          borderRadius: BorderRadius.circular(6.0),
          border: Border.all(
            color: primaryColor,
            width: 1.0,
          ),
        ),
        defaultTextStyle: TextStyle(
          // ➎ 기본 글꼴
          fontWeight: FontWeight.w600,
          color: dartGreyColor,
        ),
        weekendTextStyle: TextStyle(
          // ➏ 주말 글꼴
          fontWeight: FontWeight.w600,
          color: dartGreyColor,
        ),
        selectedTextStyle: const TextStyle(
          // ➐ 선택된 날짜 글꼴
          fontWeight: FontWeight.w600,
          color: primaryColor,
        ),
      ), // ➌ 화면에 보여지는 날
    );
  }
}

class ImageWidget extends StatelessWidget {
  const ImageWidget({
    super.key,
    required this.photosByDatetime,
    required this.d,
  });

  final Map<DateTime, ImageProvider>? photosByDatetime;
  final DateTime d;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: photosByDatetime?[d] != null
            ? DecorationImage(image: photosByDatetime![d] as ImageProvider)
            : null,
      ),
    );
  }
}
