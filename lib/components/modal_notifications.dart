import 'package:doctorfriend/components/loading_indicator.dart';
import 'package:doctorfriend/components/modal.dart';
import 'package:doctorfriend/models/notification_app.dart';
import 'package:doctorfriend/models/schedule_time_of_day.dart';
import 'package:doctorfriend/screens/schedule/achedule_customer.dart';
import 'package:doctorfriend/services/notificatios/notificatios_service.dart';
import 'package:doctorfriend/services/schedule/schedule_service.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:doctorfriend/utils/app_routes_util.dart';
import 'package:doctorfriend/utils/formater_util.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ModalNotifications {
  ModalNotifications(BuildContext context) {
    _modal(context);
  }

  static void _modal(BuildContext context) {
    Modal(
      context,
      child: StreamBuilder<List<NotificationApp>>(
          stream: NotificationsService().notifications(),
          builder: (context, snapshot) {
            final List<NotificationApp> notifications = snapshot.data ?? [];
            bool loading = snapshot.connectionState == ConnectionState.waiting;

            final error = snapshot.error;

            if (notifications.isNotEmpty) {
              NotificationsService().markAsOpen(notifications);
            }
            final traslation =
                Translations.of(context).translate('notifications');
            return LoadingIndicator(
              loading: loading,
              error: error != null,
              errorMessage: error.toString(),
              child: SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 1.6,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        traslation["title"],
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: notifications.length,
                        itemBuilder: (ctx, index) {
                          final val = notifications[index];
                          return Container(
                            decoration: BoxDecoration(
                                border: Border(
                              bottom: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .tertiary
                                    .withValues(alpha: .6),
                                width: 0.5,
                              ),
                            )),
                            child: ListTile(
                              minVerticalPadding: 15.0,
                              title: Text(val.title),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5.0),
                                    child: Text(
                                      FormaterUtil.formatDate(
                                        val.notificationDate,
                                        true,
                                      ),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground
                                                .withValues(alpha: .4),
                                          ),
                                    ),
                                  ),
                                  Text(val.message),
                                ],
                              ),
                              onTap: () {
                                openNotification(context, val);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  static void openNotification(
      BuildContext context, NotificationApp val) async {
    if (val.type == NotificationsType.schedule ||
        val.type == NotificationsType.unschedule) {
      _openSchedule(context: context, userId: val.userId, data: val);
    } else if (val.type == NotificationsType.freeTrialExpiration) {
      context.push(AppRoutesUtil.premium);
    } else if (val.type == NotificationsType.evaluation) {
      context.push(AppRoutesUtil.evaluations, extra: {
        'evaluationId': val.data?['evaluationId'],
      });
    }
    // _modal(context);
  }

  static void _openSchedule({
    required NotificationApp data,
    required String userId,
    required BuildContext context,
  }) async {
    // final int day = date.day;
    final String referenceId = data.referenceId!;
    try {
      final ScheduletimeOfDay? scheduletimeOfDaySaved =
          await ScheduleService().getScheduleDayHistory(
        referenceId: referenceId,
      );

      if (scheduletimeOfDaySaved == null) {
        return;
      }

      // subscription = scheduleMonthStream.listen((scheduleDays) async {
      //   if (scheduleDays != null) {
      //     final List<ScheduletimeOfDay> time = scheduleDays;
      //     time.removeWhere(
      //       (element) =>
      //           element.customerId != customerId || element.customerId == null,
      //     );

      // final ScheduletimeOfDay? scheduletimeOfDay =
      //     time.isNotEmpty ? time[0] : null;
      // // print(scheduleMonth);
      // // // if (scheduletimeOfDay == null) return;

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScheduleCustomer(
            scheduletimeOfDay: scheduletimeOfDaySaved,
          ),
        ),
      );
    } catch (error) {
      // print(error);
    }
  }
}
