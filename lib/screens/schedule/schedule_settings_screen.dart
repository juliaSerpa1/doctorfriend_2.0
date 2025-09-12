import 'package:doctorfriend/components/date_filter_navigation.dart';
import 'package:doctorfriend/components/loading_indicator.dart';
import 'package:doctorfriend/models/app_user.dart';
import 'package:doctorfriend/models/schedule_year.dart';
import 'package:doctorfriend/screens/schedule/components/month_schedule_card.dart';
import 'package:doctorfriend/services/auth/auth_service.dart';
import 'package:doctorfriend/services/schedule/schedule_service.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:doctorfriend/utils/app_routes_util.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScheduleSettingsScreen extends StatefulWidget {
  const ScheduleSettingsScreen({super.key});

  @override
  State<ScheduleSettingsScreen> createState() => _ScheduleSettingsScreenState();
}

class _ScheduleSettingsScreenState extends State<ScheduleSettingsScreen> {
  DateTime _date = DateTime.now();
  final AppUser _user = AuthService().currentUser!;
  void _onchangeDate(DateTime date) {
    setState(() {
      _date = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    final traslationContext = Translations.of(context);
    final traslation = traslationContext.translate('settings_schedule');
    return Scaffold(
      appBar: AppBar(
        title: Text(traslation["title"]),
        actions: [
          IconButton(
            onPressed: () => context.push(AppRoutesUtil.scheduleEditDays),
            icon: const Icon(
              Icons.save_outlined,
            ),
          ),
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            DateFillterNavigation(
              _onchangeDate,
              initialDate: _date,
            ),
            Expanded(
              child: StreamBuilder<ScheduleYear?>(
                stream: ScheduleService()
                    .scheduleYear(userId: _user.id, year: _date.year),
                builder: (context, snapshot) {
                  final ScheduleYear? scheduleYear = snapshot.data;
                  bool loading =
                      snapshot.connectionState == ConnectionState.waiting;

                  final error = snapshot.error;

                  return LoadingIndicator(
                    loading: loading,
                    error: error != null,
                    errorMessage: error.toString(),
                    child: MonthsScheduleCard(
                      scheduleYear: scheduleYear,
                      date: _date,
                      user: _user,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
