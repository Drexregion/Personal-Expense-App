import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses/models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTransaction;
  TransactionList(this.transactions, this.deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: <Widget>[
                Text('No transactions added yet',
                    style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: 20),
                Container(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset(
                    "assets/images/waiting.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            );
          })
        : ListView.builder(
            // The list view has an infinite height
            itemBuilder: (ctx, index) {
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 5,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Padding(
                        padding: EdgeInsets.all(6),
                        child: FittedBox(
                          child: Text('\$${transactions[index].amount}'),
                        )),
                  ),
                  title: Text(
                    transactions[index].title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle:
                      Text(DateFormat.yMMMd().format(transactions[index].date)),
                  trailing: MediaQuery.of(context).size.width > 460
                      ? ElevatedButton.icon(
                          icon: Icon(Icons.delete),
                          label: Text('Delete'),
                          onPressed: () =>
                              deleteTransaction(transactions[index].id),
                        )
                      : IconButton(
                          icon: Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () {
                            deleteTransaction(transactions[index].id);
                          },
                        ),
                ),
              );
              // return Card(
              //     child: Row(
              //   children: <Widget>[
              //     Container(
              //       padding: EdgeInsets.all(10),
              //       margin:
              //           EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              //       decoration: BoxDecoration(
              //           border: Border.all(
              //               color: Theme.of(context).primaryColor, width: 2)),
              //       child: Text(
              //         ' \$${transactions[index].amount.toStringAsFixed(2)}',
              //         style: TextStyle(
              //           fontWeight: FontWeight.bold,
              //           fontSize: 20,
              //           color: Theme.of(context).primaryColor,
              //         ),
              //       ),
              //     ),
              //     Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text(
              //           transactions[index].title,
              //           style: Theme.of(context).textTheme.titleMedium,
              //         ),
              //         Text(
              //             DateFormat("yyyy/MM/dd")
              //                 .format(transactions[index].date),
              //             style: TextStyle(
              //               fontSize: 12,
              //               color: Colors.grey,
              //             )),
              //       ],
              //     )
              //   ],
              // ));
            },
            itemCount: transactions.length,
            // children: [
            //   ...transactions.map((items) {
            //     );
            //   })
            // ],
          );
  }
}
