import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './models/transactions.dart';
import './widgets/transactions_list.dart';
import './widgets/new_transactions.dart';
import './widgets/chart.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Personal Expenses',
        home: MyHomePage(),
        theme: ThemeData(
            primaryColor: Color(0xff1ED7AF), //Caribean Green
            accentColor: Color(0xffE86A92), //Cyclamen
            errorColor: Colors.red[400],
            fontFamily: 'Quicksand',
            textTheme: TextTheme(
              headline6: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xff344246), //Outer Space Caryola,
              ),
              button: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xffE86A92),
              ),
              bodyText1: TextStyle(fontSize: 15),
            ),
            colorScheme: ColorScheme.light(primary: const Color(0xff1ED7AF)),
            appBarTheme: AppBarTheme(
                textTheme: ThemeData.light().textTheme.copyWith(
                        headline6: TextStyle(
                      fontFamily: 'Opensans',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    )))));
  }
}

class MyHomePage extends StatefulWidget {
  // String titleInput;
  // String amountInput;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transactions> _userTransactions = [
    // Transactions(
    //     id: 't1', title: 'Course', amount: 13.99, date: DateTime.now()),
    // Transactions(id: 't2', title: 'Grocery', amount: 30, date: DateTime.now()),
  ];
  List<Transactions> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _AddNewTx(String txTitle, double txAmount, DateTime choseenDate) {
    final newTx = Transactions(
        title: txTitle,
        amount: txAmount,
        date: choseenDate,
        id: DateTime.now().toString());
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (_) {
          return GestureDetector(
              onTap: () {},
              behavior: HitTestBehavior.opaque,
              child: NewTransactions(_AddNewTx));
        });
  }

  bool _showChart = false;
  void deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  List<Widget> _buildPortraitContent(AppBar appBar, Widget txListWidget) {
    return [
      Container(
        height: (MediaQuery.of(context).size.height -
                appBar.preferredSize.height -
                MediaQuery.of(context).padding.top) *
            0.27,
        child: Chart(_recentTransactions),
      ),
      txListWidget
    ];
  }

  List<Widget> _buildLandscapeContent(AppBar appBar, Widget txListWidget) {
    return [
      _showChart
          ? Container(
              height: (MediaQuery.of(context).size.height -
                      appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top) *
                  0.73,
              child: Chart(_recentTransactions),
            )
          : txListWidget,
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Show Chart',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Switch.adaptive(
              activeColor: Theme.of(context).accentColor,
              value: _showChart,
              onChanged: (val) {
                setState(() {
                  _showChart = val;
                });
              }),
        ],
      )
    ];
  }

  Widget _buildAppBarContent() {
    return Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Personal Expenses'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => startAddNewTransaction(context),
                  child: Icon(CupertinoIcons.add),
                ),
              ],
            ),
          )
        : AppBar(
            title: Text('Personal Expenses'),
            actions: [
              IconButton(
                  onPressed: () => startAddNewTransaction(context),
                  icon: Icon(Icons.add))
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    final inLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = _buildAppBarContent();
    final txListWidget = Container(
      height: (MediaQuery.of(context).size.height -
              appBar.preferredSize.height -
              MediaQuery.of(context).padding.top) *
          0.73,
      child: TransactionsList(_userTransactions, deleteTransaction),
    );
    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (!inLandscape) ..._buildPortraitContent(appBar, txListWidget),
            if (inLandscape) ..._buildLandscapeContent(appBar, txListWidget),
          ],
        ),
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(navigationBar: appBar, child: pageBody)
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButton: Platform.isIOS
                ? Container()
                : Visibility(
                    visible: !inLandscape,
                    child: FloatingActionButton(
                      onPressed: () => startAddNewTransaction(context),
                      child: Icon(Icons.add),
                      backgroundColor: Theme.of(context).accentColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
          );
  }
}
