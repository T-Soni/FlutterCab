import 'package:flutter_cab/main.dart';
import 'package:intl/intl.dart';

String getDropOffTime(num duration) {
  int minutes = (duration / 60).round();
  int seconds = (duration % 60).round();
  DateTime tripEndDateTime =
      DateTime.now().add(Duration(minutes: minutes, seconds: seconds));
  String dropOffTime = DateFormat.jm().format(tripEndDateTime);
  DateTime now = DateTime.now();
  String pickUpTime = DateFormat.jm().format(now);
  String formattedDate = DateFormat('dd.MM.yyyy ').format(now);
  print('Current date and time: $formattedDate');
  String tripTime = formattedDate + pickUpTime + '->' + dropOffTime;
  sharedPreferences.setString('tripTime', tripTime);
  print(tripTime);
  print(dropOffTime);
  return dropOffTime;
}
