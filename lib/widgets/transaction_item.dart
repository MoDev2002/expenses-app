import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transactions.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    Key key,
    @required this.transaction,
    @required this.curStateFactor,
    @required this.deleteTx,
  }) : super(key: key);

  final Transactions transaction;
  final double curStateFactor;
  final Function deleteTx;

  @override
  _TransactionItemState createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  Color _bgColor;
  @override
  void initState() {
    super.initState();
    const availableColors = [
      Color(0xff1ED7AF),
      Colors.amber,
      Colors.purple,
      Colors.blue
    ];
    _bgColor = availableColors[Random().nextInt(4)];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(60),
          side: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 1,
          )),
      elevation: 5,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _bgColor,
          foregroundColor: Colors.white,
          radius: 40,
          // child: SizedBox(
          child: Padding(
              padding: EdgeInsets.all(5),
              child: FittedBox(
                child: Text(
                  '${widget.transaction.amount.toStringAsFixed(1)}\$',
                  style: TextStyle(
                    fontSize: 20 * widget.curStateFactor,
                  ),
                ),
              )),
        ),
        title: Text(
          widget.transaction.title,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(DateFormat.yMMMEd().format(widget.transaction.date)),
        trailing: MediaQuery.of(context).size.width > 500
            ? FlatButton.icon(
                textColor: Theme.of(context).errorColor,
                icon: Icon(Icons.delete),
                label: Text('Delete'),
                onPressed: () => widget.deleteTx(widget.transaction.id),
              )
            : IconButton(
                icon: Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () => widget.deleteTx(widget.transaction.id),
                iconSize: 28,
              ),
      ),
    );
  }
}
