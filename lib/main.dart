// Good Convention have your dart imports in the first line
import 'dart:io';

// Flutter and packages imports on the next line
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Personal custom classes on the third import
import 'package:personal_expenses/models/transaction.dart';
import 'package:personal_expenses/widgets/chart.dart';
import 'package:personal_expenses/widgets/new_transactions.dart';
import 'package:personal_expenses/widgets/transaction_list.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();

  // Changes the system settings of mobile phone
  // This forces the app into portrait mode
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        // Note Material will soom be deprecated and we should start using material3!!!
        useMaterial3: false,
        // Gives a color which can be used all over the app with dfferent shades
        primarySwatch: Colors.purple,
        fontFamily: "Quicksand",
        textTheme: ThemeData.light().textTheme.copyWith(
              titleMedium: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontFamily: "OpenSans",
                fontWeight: FontWeight.bold,
              ),
              displaySmall: TextStyle(color: Colors.white),
            ),
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontFamily: "OpenSans",
            fontWeight: FontWeight.bold,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.amber,
          foregroundColor: Colors.black,
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // String? titleInput;
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  final List<Transaction> _userTransactions = [
    // Transaction(
    //     id: "t1", title: "New Shoes", amount: 69.99, date: DateTime.now()),
    // Transaction(
    //     id: "t2", title: "Groceries", amount: 69.99, date: DateTime.now()),
    // Transaction(
    //     id: "t3", title: "Monitor", amount: 69.99, date: DateTime.now()),
    // Transaction(
    //     id: "t4", title: "App fees", amount: 69.99, date: DateTime.now()),
  ];

// getters functions used to get transactins
  List<Transaction> get _recentTransactions {
    // where iterates through out a list and keeps the elements that pass the functions
    return _userTransactions.where(
      (tx) {
        return tx.date.isAfter(
          DateTime.now().subtract(
            Duration(days: 7),
          ),
        );
      },
    ).toList();
  }

// add new transaction, the state is managed here
  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
        title: txTitle,
        amount: txAmount,
        date: chosenDate,
        id: DateTime.now().toString());

    // recalls the build functions
    setState(
      () => _userTransactions.add(newTx),
      // print(_userTransactions),
    );
  }

  bool _showChart = false;

// show modal for input
  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        // ctx is the context of the app
        context: ctx,

        // btx is the context the modal returns
        builder: (bctx) {
          return GestureDetector(
            onTap: () {},
            child: NewTransactions(_addNewTransaction),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) {
        return tx.id == id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    // Good practise create variables for repeated code
    final mediaQuery = MediaQuery.of(context);

    PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text(
              'Personal Expenses',
              style: TextStyle(fontFamily: "OpenSans"),
            ),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
              GestureDetector(
                child: Icon(CupertinoIcons.add),
                onTap: () => _startAddNewTransaction(context),
              ),
            ]))
        : AppBar(
            title: Text(
              'Personal Expenses',
              style: TextStyle(fontFamily: "OpenSans"),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _startAddNewTransaction(context),
              ),
            ],
          );

    final txListWidget = Container(
      height:
          (MediaQuery.of(context).size.height - appBar.preferredSize.height) *
              0.7,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
        
                    "Show Chart",style: Theme.of(context).textTheme.titleMedium),
                  Switch.adaptive(
                    activeColor: Theme.of(context)
                        .floatingActionButtonTheme
                        .backgroundColor,
                    value: _showChart,
                    onChanged: (value) {
                      setState(() {
                        _showChart = value;
                      });
                    },
                  ),
                ],
              ),
            if (!isLandscape)
              Container(
                height: (mediaQuery.size.height - appBar.preferredSize.height) *
                    0.3,
                child: Chart(_recentTransactions),
              ),
            if (!isLandscape) txListWidget,
            if (isLandscape)
              _showChart
                  ? Container(
                      height: (mediaQuery.size.height -
                              appBar.preferredSize.height) *
                          0.7,
                      child: Chart(_recentTransactions),
                    )
                  :
                  // NewTransactions(_addNewTransaction),
                  txListWidget,
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(child: pageBody)
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
          );
  }
}
