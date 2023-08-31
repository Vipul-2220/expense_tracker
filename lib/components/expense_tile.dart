import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ExpenseTile extends StatefulWidget {
  final String name;
  final String amount;
  final DateTime dateTime;
  void Function(BuildContext)? deleteTapped;

  ExpenseTile({
    super.key,
    required this.name,
    required this.amount,
    required this.dateTime,
    required this.deleteTapped,
  });

  @override
  State<ExpenseTile> createState() => _ExpenseTileState();
}

class _ExpenseTileState extends State<ExpenseTile> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          // delete button
          SlidableAction(
            onPressed: widget.deleteTapped,
            icon: Icons.delete,
          ),
        ],
      ),
      child: ListTile(
        title: Text(widget.name),
        subtitle: Text(widget.dateTime.day.toString() +
            '/' +
            widget.dateTime.month.toString() +
            '/' +
            widget.dateTime.year.toString()),
        trailing: Text('Rs.' + widget.amount),
      ),
    );
  }
}
