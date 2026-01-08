import 'package:doctorfriend/components/loading_indicator.dart';
import 'package:doctorfriend/models/app_user.dart';
import 'package:doctorfriend/models/schedule_time_of_day.dart';
import 'package:doctorfriend/screens/schedule/components/days_slide.dart';
import 'package:doctorfriend/screens/schedule/components/notification_button.dart';
import 'package:doctorfriend/services/auth/auth_service.dart';
import 'package:doctorfriend/services/schedule/schedule_service.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:doctorfriend/utils/app_routes_util.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:doctorfriend/components/gradient_app_bar.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final AppUser _user = AuthService().currentUser!;
  DateTime _month = DateTime.now();

  void _updateDate(DateTime date) {
    setState(() {
      _month = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    final traslation = Translations.of(context).translate('schedule');
    return Scaffold(
      appBar: GradientAppBar(
        title: traslation["title"],
        leading: const NotificationButton(),
        actions: [
          IconButton(
            onPressed: () => context.push(AppRoutesUtil.scheduleSettings),
            icon: const Icon(
              Icons.edit_calendar_outlined,
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<ScheduletimeOfDay>?>(
        stream: ScheduleService().scheduleMonth(
          userId: _user.id,
          month: DateTime(_month.year, _month.month),
        ),
        builder: (context, snapshot) {
          final List<ScheduletimeOfDay> scheduletimesOfDay =
              snapshot.data ?? [];
          bool loading = snapshot.connectionState == ConnectionState.waiting;

          final error = snapshot.error;

          return LoadingIndicator(
            loading: false,
            error: error != null,
            errorMessage: error.toString(),
            child: DaysSlide(
              scheduletimesOfDay: scheduletimesOfDay,
              updateDate: _updateDate,
              selectedMonth: _month,
              loading: loading,
            ),
          );
        },
      ),
    );
  }
}
