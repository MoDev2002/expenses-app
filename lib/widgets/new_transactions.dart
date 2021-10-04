
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './adaptive_flat_button.dart';
class NewTransactions extends StatefulWidget {
  final Function NewTx;

  NewTransactions(this.NewTx);

  @override
  _NewTransactionsState createState() => _NewTransactionsState();
}

class _NewTransactionsState extends State<NewTransactions> {
  final titleController = TextEditingController();

  final amountController = TextEditingController();
  DateTime selectedDate;

  void submitData() {
    if (titleController.text.isEmpty) {
      return;
    }
    final enteredTitleController = titleController.text;
    final double enteredAmountController = double.parse(amountController.text);

    if (enteredTitleController.isEmpty ||
        enteredAmountController <= 0 ||
        selectedDate == null) {
      return;
    }
    widget.NewTx(
      titleController.text,
      double.parse(amountController.text),
      selectedDate,
    );
    Navigator.of(context).pop();
  }

  void presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        return selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final inLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Card(
      elevation: 5,
      child: Container(
        height: !inLandscape
            ? MediaQuery.of(context).size.height / 2.5 +
                MediaQuery.of(context).viewInsets.bottom
            : MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10,
          bottom:
              !inLandscape ? MediaQuery.of(context).viewInsets.bottom + 10 : 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
              controller: titleController,
              onSubmitted: (_) => submitData(),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Amount'),
              controller: amountController,
              keyboardType: TextInputType.number,
              onSubmitted: (_) => submitData(),
            ),
            Container(
              height: 70,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedDate == null
                          ? 'No Date Selected'
                          : 'The Selected Date : ${DateFormat.yMMMMd().format(selectedDate)}',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  AdaptiveFlatButton(buttonText: 'Choose Date', buttonHandler: presentDatePicker,)
                ],
              ),
            ),
            Spacer(),
            Container(
              height: 75,
              child: TextButton(
                onPressed: submitData,
                child: Text('Add Transaction', 
                              style: TextStyle(color: Colors.teal),),
              ),
            )
          ],
        ),
      ),
    );
  }
}
