// convert DateTime object to a string yyyymmdd

String convertDateTime(DateTime dateTime) {
  // year  in the yyyy format
  String year = dateTime.year.toString();

  // month in the mm format
  String month = dateTime.month.toString();
  if (month.length == 1) {
    month = '0$month';
  }

  // day in the format
  String day = dateTime.day.toString();
  if (day.length == 1) {
    day = '0$day';
  }

  // final format in yyyymmdd
  String yyyymmdd = year + month + day;

  return yyyymmdd;
}
