import 'package:doctorfriend/models/schedule_time_of_day.dart';
import 'package:doctorfriend/screens/schedule/achedule_customer.dart';
import 'package:doctorfriend/utils/formater_util.dart';
import 'package:flutter/material.dart';

class TimeOfDayBox extends StatelessWidget {
  final Function(DateTime) deleteOne;
  final Function(TimeOfDay) addOne;
  final List<ScheduletimeOfDay> timesOfDay;
  final DateTime date;
  const TimeOfDayBox({
    super.key,
    required this.addOne,
    required this.deleteOne,
    required this.timesOfDay,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    openTimePicker() async {
      TimeOfDay? newTime = await showTimePicker(
        context: context,
        initialTime: const TimeOfDay(hour: 12, minute: 0),
      );

      if (newTime != null) {
        addOne(newTime);
      }
    }

    goToSchedule(ScheduletimeOfDay scheduletimeOfDay) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScheduleCustomer(
            scheduletimeOfDay: scheduletimeOfDay,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: timesOfDay.length + 1,
      itemBuilder: (ct, index) {
        if (timesOfDay.length == index) {
          return IconButton(
            onPressed: openTimePicker,
            icon: Icon(
              Icons.add_alarm,
              color: Theme.of(context).colorScheme.primary,
              size: 33,
            ),
          );
        }
        final scheduletimeOfDay = timesOfDay[index];
        final String time =
            "${FormaterUtil.addZero(scheduletimeOfDay.timeOfDay.hour)}:${FormaterUtil.addZero(timesOfDay[index].timeOfDay.minute)}";
        final bool isTelemedicine = scheduletimeOfDay.isTelemedicine;
        return Container(
          margin: const EdgeInsets.only(top: 10.0),
          padding: const EdgeInsets.all(6.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Theme.of(context).colorScheme.primary.withValues(alpha: .1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                time,
                textAlign: TextAlign.center,
              ),
              if (isTelemedicine)
                Icon(
                  Icons.videocam_outlined,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              if (!timesOfDay[index].isSchedule)
                InkWell(
                  onTap: () => deleteOne(timesOfDay[index].timeOfDay),
                  child: Icon(
                    Icons.delete,
                    color: Theme.of(context).colorScheme.error,
                  ),
                )
              else
                InkWell(
                  onTap: () => goToSchedule(timesOfDay[index]),
                  child: Icon(
                    Icons.person_pin_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
