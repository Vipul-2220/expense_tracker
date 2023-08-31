import 'package:expense_tracker/data/hive_database.dart';
import 'package:expense_tracker/datetime/date_time_helper.dart';
import 'package:expense_tracker/models/expense_item.dart';
import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';

class ExpenseData extends ChangeNotifier {
  // List of all expenses
  List<ExpenseItem> overallExpenseList = [];

  // get all expense list

  List<ExpenseItem> getAllExpenseList() {
    return overallExpenseList;
  }

  // prepare data to display
  final db = HiveDataBase();
  void prepareData() {
    // if there exist a data get it
    if (db.readData().isNotEmpty) {
      overallExpenseList = db.readData();
    }
  }

  //add new expense
  void addNewExpense(ExpenseItem newExpense) {
    overallExpenseList.add(newExpense);
    notifyListeners();
    db.saveData(overallExpenseList);
  }

  // delete an expense
  void deleteExpense(ExpenseItem expense) {
    overallExpenseList.remove(expense);
    notifyListeners();
    db.saveData(overallExpenseList);
  }

  // get a weekday (mon, tue, wed, etc) from a dateTime object
  String getDayName(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return 'Mon';

      case 2:
        return 'Tue';

      case 3:
        return 'Wed';

      case 4:
        return 'Thur';

      case 5:
        return 'Fri';

      case 6:
        return 'Sat';

      case 7:
        return 'Sun';

      default:
        return '';
    }
  }

  // get the date for the start of the week (sunday)
  DateTime startOfTheWeekDate() {
    DateTime? startOfTheWeek;

    //get today's date
    DateTime today = DateTime.now();

    //go backwards from today to find sunday
    for (int i = 0; i < 7; i++) {
      if (getDayName(today.subtract(Duration(days: i))) == 'Sun') {
        startOfTheWeek = today.subtract(Duration(days: i));
      }
    }
    return startOfTheWeek!;
  }

  /*

  convert overall list of expenses into a daily expense summary

  e.g.

    overallExpenseList = 
    [

      [food,2023/01/30, $10]
      [food,2023/01/30, $10]
      [food,2023/02/01, $10]
      [food,2023/02/01, $10]
      [food,2023/02/03, $10]
      [food,2023/01/05, $10]
      [food,2023/01/05, $10]

    ]

    dailyExpenseSummary = 
    [

      [2023/01/30: $20]
      [2023/01/01: $20]
      [2023/01/03: $10]
      [2023/01/05: $20]

    ]


  */

  Map<String, double> calculateDailyExpenseSummary() {
    Map<String, double> dailyExpenseSummary = {
      // date (yyyymmdd) : amountTotalForDay
    };

    for (var expense in overallExpenseList) {
      String date = convertDateTime(expense.dateTime);
      double amount = double.parse(expense.amount);

      if (dailyExpenseSummary.containsKey(date)) {
        double currentAmount = dailyExpenseSummary[date]!;
        currentAmount += amount;
        dailyExpenseSummary[date] = currentAmount;
      } else {
        dailyExpenseSummary.addAll({date: amount});
      }
    }

    return dailyExpenseSummary;
  }
}
