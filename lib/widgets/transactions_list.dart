import 'package:flutter/material.dart';
import './transaction_item.dart';
import '../models/transactions.dart';

class TransactionsList extends StatelessWidget {
  final List<Transactions> transactions;
  final Function deleteTx;
  TransactionsList(this.transactions, this.deleteTx);
  @override
  Widget build(BuildContext context) {
    final curStateFactor = MediaQuery.of(context).textScaleFactor;
    return transactions.isEmpty
        ? LayoutBuilder(builder: (context, constraints) {
            return Column(
              children: [
                Text(
                  'Waitnig for your first transaction!',
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                )
              ],
            );
          })
        : ListView(
            children: transactions
                .map((tx) => TransactionItem(
                    key: ValueKey(tx.id),
                    transaction: tx,
                    curStateFactor: curStateFactor,
                    deleteTx: deleteTx))
                .toList(),
          );
  }
}
