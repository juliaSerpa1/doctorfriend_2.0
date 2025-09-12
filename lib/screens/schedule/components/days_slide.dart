import 'package:doctorfriend/models/schedule_time_of_day.dart';
import 'package:doctorfriend/screens/schedule/components/day_card.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class DaysSlide extends StatefulWidget {
  final List<ScheduletimeOfDay> scheduletimesOfDay;
  final Function(DateTime) updateDate;
  final DateTime selectedMonth;
  final bool loading;

  const DaysSlide({
    super.key,
    required this.scheduletimesOfDay,
    required this.updateDate,
    required this.selectedMonth,
    required this.loading,
  });

  @override
  State<DaysSlide> createState() => _DaysSlideState();
}

class _DaysSlideState extends State<DaysSlide> {
  late DateTime _date;
  int _lastIndex = 0;

  bool islaft(int index) {
    return _lastIndex == 0 && index == 2 ||
        _lastIndex == 1 && index == 0 ||
        _lastIndex == 2 && index == 1;
  }

  void onPageChanged(int index, CarouselPageChangedReason reason) {
    if (islaft(index)) {
      _updateDate(_date.subtract(const Duration(days: 1)));
    } else {
      _updateDate(_date.add(const Duration(days: 1)));
    }
    setState(() {
      _lastIndex = index;
    });
  }

  void _updateDate(DateTime date) {
    _date = date;
    if (widget.selectedMonth.year != _date.year ||
        widget.selectedMonth.month != _date.month) {
      widget.updateDate(_date);
    } else {
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      _date = widget.selectedMonth;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        aspectRatio: 1 / 1.8,
        height: MediaQuery.of(context).size.height,
        viewportFraction: 0.92,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: false,
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        enlargeFactor: 0.15,
        scrollDirection: Axis.horizontal,
        onPageChanged: onPageChanged,
      ),
      items: [
        0,
        1,
        2,
      ].map(
        (index) {
          DateTime date = DateTime(_date.year, _date.month, _date.day);
          DateTime date1 = DateTime(_date.year, _date.month, _date.day);
          DateTime date2 = DateTime(_date.year, _date.month, _date.day);
          if (index != _lastIndex) {
            if (_lastIndex == 0 && index == 2 || index == _lastIndex - 1) {
              date = date1.subtract(const Duration(days: 1));
            }
            if (_lastIndex == 2 && index == 0 || index == _lastIndex + 1) {
              date = date2.add(const Duration(days: 1));
            }
          }

          final day = date.day;
          List<ScheduletimeOfDay> scheduletimesOfDayFiltered = [
            ...widget.scheduletimesOfDay
          ];
          scheduletimesOfDayFiltered
              .removeWhere((element) => element.timeOfDay.day != day);
          return DayCard(
            day: date,
            updateDate: _updateDate,
            scheduletimesOfDay: scheduletimesOfDayFiltered,
            loading: widget.loading || _date.month != date.month,
            isNotRegistered: widget.scheduletimesOfDay.isEmpty,
          );
        },
      ).toList(),
    );
  }
}
