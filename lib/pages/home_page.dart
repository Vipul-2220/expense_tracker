import 'package:expense_tracker/components/expense_summary.dart';
import 'package:expense_tracker/components/expense_tile.dart';
import 'package:expense_tracker/data/expense_data.dart';
import 'package:expense_tracker/models/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final newExpenseNameController = TextEditingController();
  final newExpenseAmountController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // prepare data on startup
    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }

  // add new expense
  void addNewExpense() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add new expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // expense name
            TextField(
              decoration: const InputDecoration(hintText: 'Expense Name'),
              controller: newExpenseNameController,
            ),

            // expense data
            TextField(
              decoration: const InputDecoration(hintText: 'Amount'),
              keyboardType: TextInputType.number,
              controller: newExpenseAmountController,
            ),
          ],
        ),
        actions: [
          // save button
          MaterialButton(
            onPressed: save,
            child: Text('Save'),
          ),

          // cancel button
          MaterialButton(
            onPressed: cancel,
            child: Text('Cancel'),
          )
        ],
      ),
    );
  }

  void deleteExpense(ExpenseItem expense) {
    Provider.of<ExpenseData>(context, listen: false).deleteExpense(expense);
  }

  void save() {
    ExpenseItem newExpense = ExpenseItem(
      name: newExpenseNameController.text,
      amount: newExpenseAmountController.text,
      dateTime: DateTime.now(),
    );

    // add the new expense
    Provider.of<ExpenseData>(context, listen: false).addNewExpense(newExpense);

    Navigator.pop(context);
    clear();
  }

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    newExpenseAmountController.clear();
    newExpenseNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Scaffold(
          backgroundColor: Colors.grey[300],
          floatingActionButton: FloatingActionButton(
            onPressed: addNewExpense,
            backgroundColor: Colors.black,
            child: Icon(Icons.add),
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: ListView(
              children: [
                // weekly summary
                ExpenseSummary(startOfWeek: value.startOfTheWeekDate()),

                // expense list
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: value.getAllExpenseList().length,
                  itemBuilder: (context, index) => ExpenseTile(
                    name: value.getAllExpenseList()[index].name,
                    amount: value.getAllExpenseList()[index].amount,
                    dateTime: value.getAllExpenseList()[index].dateTime,
                    deleteTapped: (context) =>
                        deleteExpense(value.getAllExpenseList()[index]),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
