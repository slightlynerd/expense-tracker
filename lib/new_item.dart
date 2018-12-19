import 'package:flutter/material.dart';
import 'new_sales.dart';
import 'new_purchase.dart';
import 'new_other_income.dart';

class NewItem extends StatefulWidget {

  @override
  _NewItems createState() => _NewItems();
}

class _NewItems extends State<NewItem> {
  
  void _newItem(String content) {
    content = content.toLowerCase();
      if (content == 'sales') {
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => NewSales())
        );
      }
      else if (content == 'purchase') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NewPurchase())
        );
      }
      else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NewOtherIncome())
        );
      }
  }

  @override
  Widget build(BuildContext context) {

    Column buildCard(String content) {

      return Column(
        children: [
          Card(
            elevation: 2.0,
            margin: EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: FlatButton(
                    onPressed: () {
                      _newItem(content);
                    },
                    child: Text(
                      content,
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    Widget expenses = Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          buildCard('SALES'),
          buildCard('PURCHASE'),
          buildCard('OTHER INCOME'),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('New'),
      ),
      body: Column(
        children: [
          expenses,
        ],
      ),
    );
  }
}