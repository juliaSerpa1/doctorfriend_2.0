import 'package:flutter/material.dart';
import 'package:doctorfriend/models/app_user.dart';
import 'package:doctorfriend/models/schedule_month.dart';
import 'package:doctorfriend/models/schedule_time_of_day.dart';
import 'package:doctorfriend/models/schedule_year.dart';
import 'package:doctorfriend/screens/schedule/schedule_edit_month_screen.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:doctorfriend/utils/formater_util.dart';

class MonthsScheduleCard extends StatelessWidget {
  const MonthsScheduleCard({
    super.key,
    required this.scheduleYear,
    required this.date,
    required this.user,
  });

  final ScheduleYear? scheduleYear;
  final DateTime date;
  final AppUser user;

  @override
  Widget build(BuildContext context) {
    final montsOfYear =
        Translations.of(context).translate('months_of_year')["list"];
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.center,
      children: montsOfYear
          .map(
            (value) {
              final now = DateTime.now();
              final int indexMonth =
                  montsOfYear.indexWhere((element) => element == value) + 1;

              List<ScheduletimeOfDay>? scheduleMonth =
                  scheduleYear?.scheduleMonthsInYear[indexMonth];
              bool isCreated = scheduleMonth != null;

              final month = DateTime(
                date.year,
                indexMonth,
              );

              //verificar se a mes ja passou e não existe agenda criada
              // if (month.month < now.month - 1 &&
              //     month.year == now.year &&
              //     !isCreated) {
              //   return const SizedBox();
              // }
              //verificar se a ano ja passou e não existe agenda criada
              if (month.year < now.year && !isCreated) {
                return const SizedBox();
              }

              return Container(
                margin: const EdgeInsets.all(5),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScheduleEditMonth(
                          scheduleMonth: isCreated
                              ? ScheduleMonth(
                                  id: "",
                                  userId: user.id,
                                  scheduleDays: scheduleMonth,
                                  month: month,
                                  updatedDate: DateTime.now(),
                                  createdDate: DateTime.now(),
                                )
                              : ScheduleMonth(
                                  id: "",
                                  userId: user.id,
                                  scheduleDays: [],
                                  month: month,
                                  updatedDate: DateTime.now(),
                                  createdDate: DateTime.now(),
                                ),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    constraints: const BoxConstraints(minWidth: 110),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: .1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(children: [
                      Text(FormaterUtil.capitalize(value)),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Icon(
                          isCreated ? Icons.check : Icons.close_sharp,
                          color: isCreated
                              ? Theme.of(context).colorScheme.secondaryContainer
                              : Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ]),
                  ),
                ),
              );
            },
          )
          .toList()
          .cast<Widget>(),
    );
  }
}
