import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'new_item.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xFFFFDE03),
        accentColor: Color(0xFF0336FF),
        scaffoldBackgroundColor: Color(0xFFFFDE03),
      ),
      home: MyHomePage(title: 'Expense Tracker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  double _totalSales = 0.0;
  double _totalIncome = 0.0;
  double _totalPurchases = 0.0;
  double _totalOtherIncomes = 0.0;
  double _balance = 0.0;

  Future<List> _fetchCategory(String category) async {
    final SharedPreferences prefs = await _prefs;
    List<String> incomes = prefs.getStringList(category);
    return incomes;
  }

  updateUI(String str, double num) {
    setState(() {
      if (str == 'income') {
        _totalSales = num;
      }
      else if (str == 'purchases') {
        _totalPurchases = num;
      }
      else {
        _totalOtherIncomes = num;
      }
      _totalIncome = _totalSales + _totalOtherIncomes;
      _balance = _totalIncome - _totalPurchases;
    });
  }

  _initialize() {
    double totalIncome = 0;
    double totalOtherIncome = 0;
    double totalPurchases = 0;

    var income = _fetchCategory('incomes');
    var otherIncome = _fetchCategory('otherIncomes');
    var purchases = _fetchCategory('purchases');

    income.then((inc) {
      if (inc == null) {
        return;
      }
      inc.forEach((f) {
        totalIncome += double.parse(f);
      });
      updateUI('income', totalIncome);
    }).catchError((error) => print(error));

    otherIncome.then((oi) {
      if (oi == null) {
        return;
      }
      oi.forEach((o) {
        totalOtherIncome += double.parse(o);
      });
      updateUI('other income', totalOtherIncome);
    }).catchError((error) => print(error));

    purchases.then((oi) {
      if (oi == null) {
        return;
      }
      oi.forEach((o) {
        totalPurchases += double.parse(o);
      });
      updateUI('purchases', totalPurchases);
    }).catchError((error) => print(error));
  }

  @override
  Widget build(BuildContext context) {
    _initialize();

    Widget nav() {
      return Container(
        color: const Color(0xFFFFDE03),
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Dec',
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 16.0,
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black,
                          ),
                        ],
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'Expense Tracker',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        )
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '01 Dec, 2018',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Color(0xFF000000),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget dashboard(double income, double expenses) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Income',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        '$_totalIncome',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'images/shaolin.png',
                        width: 48.0,
                        height: 48.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Balance',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        '$_balance',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Expenses',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        '$_totalPurchases',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Column buildCards(IconData icon, String title, String amount) {
      return Column(
        children: [
          Card(
            elevation: 2.0,
            margin: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Icon(icon),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                      child: Text(
                        '|',
                        style: TextStyle(
                          fontSize: 30.0,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                          child: Text(
                            title,
                            style: TextStyle(
                                color: Color(0xFF212121),
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                height: 2.0,
                                textBaseline: TextBaseline.alphabetic),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 8.0, bottom: 8.0),
                          child: Text(
                            amount,
                            style: TextStyle(
                              color: Color(0xFF424242),
                              fontSize: 16.0,
                              height: 1.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    }

    Widget bodyContent = Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          buildCards(Icons.more_vert, 'SALES', _totalSales.toString()),
          buildCards(
              Icons.shopping_cart, 'PURCHASE', _totalPurchases.toString()),
          buildCards(Icons.attach_money, 'OTHER INCOMES',
              _totalOtherIncomes.toString()),
        ],
      ),
    );

    return Scaffold(
      body: ListView(
        children: [
          nav(),
          dashboard(_totalSales, _totalPurchases),
          bodyContent,
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewItem()),
          );
        },
        tooltip: 'New Expense',
        child: Icon(Icons.add),
      ),
    );
  }
}
