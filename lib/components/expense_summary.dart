import 'package:expense_tracker/bar_graph/bar_graph.dart';
import 'package:expense_tracker/data/expense_data.dart';
import 'package:expense_tracker/datetime/date_time_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseSummary extends StatefulWidget {
  final DateTime startOfWeek;
  const ExpenseSummary({super.key, required this.startOfWeek});

  @override
  State<ExpenseSummary> createState() => _ExpenseSummaryState();
}

class _ExpenseSummaryState extends State<ExpenseSummary> {
  // calulate max amount in bar graph
  double calculateMax(
    ExpenseData value,
    String sunday,
    String monday,
    String tuesday,
    String wednesday,
    String thursday,
    String friday,
    String saturday,
  ) {
    double? max = 100;

    List<double> values = [
      value.calculateDailyExpenseSummary()[sunday] ?? 0,
      value.calculateDailyExpenseSummary()[monday] ?? 0,
      value.calculateDailyExpenseSummary()[tuesday] ?? 0,
      value.calculateDailyExpenseSummary()[wednesday] ?? 0,
      value.calculateDailyExpenseSummary()[thursday] ?? 0,
      value.calculateDailyExpenseSummary()[friday] ?? 0,
      value.calculateDailyExpenseSummary()[saturday] ?? 0,
    ];

    // sort from smallest to largest
    values.sort();
    // get largest amount (which is at the end of the sorted list)
    // and increase the cap slightly so the graph looks allmost full

    max = values.last * 1.1;

    return max == 0 ? 100 : max;
  }

  // Calculate week total
  String calculateWeekTotal(
    ExpenseData value,
    String sunday,
    String monday,
    String tuesday,
    String wednesday,
    String thursday,
    String friday,
    String saturday,
  ) {
    List<double> values = [
      value.calculateDailyExpenseSummary()[sunday] ?? 0,
      value.calculateDailyExpenseSummary()[monday] ?? 0,
      value.calculateDailyExpenseSummary()[tuesday] ?? 0,
      value.calculateDailyExpenseSummary()[wednesday] ?? 0,
      value.calculateDailyExpenseSummary()[thursday] ?? 0,
      value.calculateDailyExpenseSummary()[friday] ?? 0,
      value.calculateDailyExpenseSummary()[saturday] ?? 0,
    ];

    double total = 0;
    for (int i = 0; i < values.length; i++) {
      total += values[i];
    }

    return total.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    // get yyyymmdd for each day of the week
    String sunday =
        convertDateTime(widget.startOfWeek.add(const Duration(days: 0)));
    String monday =
        convertDateTime(widget.startOfWeek.add(const Duration(days: 1)));
    String tuesday =
        convertDateTime(widget.startOfWeek.add(const Duration(days: 2)));
    String wednesday =
        convertDateTime(widget.startOfWeek.add(const Duration(days: 3)));
    String thursday =
        convertDateTime(widget.startOfWeek.add(const Duration(days: 4)));
    String friday =
        convertDateTime(widget.startOfWeek.add(const Duration(days: 5)));
    String saturday =
        convertDateTime(widget.startOfWeek.add(const Duration(days: 6)));

    return Consumer<ExpenseData>(
        builder: (context, value, data) => Column(
              children: [
                // Week total
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Row(
                    children: [
                      Text(
                        'Week Total: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Rs.' +
                            calculateWeekTotal(value, sunday, monday, tuesday,
                                wednesday, thursday, friday, saturday),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: MyBarGraph(
                    maxY: calculateMax(value, sunday, monday, tuesday,
                        wednesday, thursday, friday, saturday),
                    sunAmount:
                        value.calculateDailyExpenseSummary()[sunday] ?? 0,
                    monAmount:
                        value.calculateDailyExpenseSummary()[monday] ?? 0,
                    tueAmount:
                        value.calculateDailyExpenseSummary()[tuesday] ?? 0,
                    wedAmount:
                        value.calculateDailyExpenseSummary()[wednesday] ?? 0,
                    thurAmount:
                        value.calculateDailyExpenseSummary()[thursday] ?? 0,
                    friAmount:
                        value.calculateDailyExpenseSummary()[friday] ?? 0,
                    satAmount:
                        value.calculateDailyExpenseSummary()[saturday] ?? 0,
                  ),
                ),
              ],
            ));
  }
}
