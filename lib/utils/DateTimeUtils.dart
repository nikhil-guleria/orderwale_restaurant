import 'package:food_merchant/utils/extensions/date_time_extension.dart';
import 'package:intl/intl.dart';

class DateTimeUtils {
  static final DateTimeUtils utils = DateTimeUtils._internal();
  final String DATE_FORMAT_DD_MMM_YYYY = "dd MMM, yyyy";

  factory DateTimeUtils() {
    return utils;
  }
  DateTimeUtils._internal();


  bool isCurrentDay(String selectedDate){
    var isCurrentDay = false;
    var outputFormat = DateFormat(DATE_FORMAT_DD_MMM_YYYY);

    var date = outputFormat.format(DateTime.now());
    if(selectedDate == date) {
      isCurrentDay = true;
    }
    return isCurrentDay;
  }


  getDurationTimeAgo(String date, String format, bool isNumeric) {
    DateTime parseDate1 =  DateFormat(format).parse(date);
    var dateTimeNow = DateTime.now();
    var diffMin = dateTimeNow
        .difference(parseDate1);
    return  diffMin.timeAgo(isNumeric) ;
  }



  String extractDate(String datetimeString){
    try {
      if (datetimeString.isEmpty) return "";
      DateTime dateTime = DateTime.parse(datetimeString);
      return "${twoDigitNum(dateTime.day)}-${twoDigitNum(dateTime.month)}-${dateTime.year}";
    } catch (e){
      return "";
    }
  }
  String extractTime(String datetimeString){
    try {
      if (datetimeString.isEmpty) return "";
      DateTime dateTime = DateTime.parse(datetimeString);
      String time = "${twoDigitNum(dateTime.hour)}:${twoDigitNum(dateTime.minute)}:${twoDigitNum(dateTime.second)}";
      return DateFormat("hh:mm a").format(DateFormat("hh:mm:ss").parse(time));
    } catch (e){
      return "";
    }
  }

  String twoDigitNum(int num){
    if(num < 10){
      return "0$num";
    }
    else {
      return "$num";
    }
  }



}
