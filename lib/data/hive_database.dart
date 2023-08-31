import 'package:expense_tracker/models/expense_item.dart';
import 'package:hive/hive.dart';

class HiveDataBase {
  // reference our data
  final _myBox = Hive.box("expense_database");

  // read data
  void saveData(List<ExpenseItem> allExpenses) {
    /*

    Hive can only store strings and dateTime, and not custom objects like ExpenseItem
    So lets convert ExpenseItem objects into types that can be stored in out db

    allExpense = 

    [

      ExpenseItem (name/amount/dataTime)
      ...

    ]

    [

      [name, amount, dateTime],

    ]

    */

    List<List<dynamic>> allExpensesFormatted = [];

    for (var expense in allExpenses) {
      // convert each expense item into a list of storable types
      List<dynamic> expenseFormatted = [
        expense.name,
        expense.amount,
        expense.dateTime,
      ];
      allExpensesFormatted.add(expenseFormatted);
    }

    // Store it in database
    _myBox.put("ALL_EXPENSES", allExpensesFormatted);
  }

  // write data
  List<ExpenseItem> readData() {
    /*

    Data is stored in Hive as a list of Strings and DateTime, So lets convert our saved data into ExpenseItem objects

    savedData = 

    [

      [name, amount, dateTime]

    ]

    [

      ExpenseItem(name/amount/dateTime),

    ]

    */

    List savedExpenses = _myBox.get("ALL_EXPENSES") ?? [];
    List<ExpenseItem> allExpenses = [];

    for (int i = 0; i < savedExpenses.length; i++) {
      // collect individual expense data
      String name = savedExpenses[i][0];
      String amount = savedExpenses[i][1];
      DateTime dateTime = savedExpenses[i][2];

      ExpenseItem expense = ExpenseItem(
        name: name,
        amount: amount,
        dateTime: dateTime,
      );

      // add expenses to overall list of expenses
      allExpenses.add(expense);
    }

    return allExpenses;
  }
}
