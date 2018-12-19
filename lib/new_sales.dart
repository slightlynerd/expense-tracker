import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

class NewSales extends StatefulWidget {
  @override
  _NewSalesState createState() => _NewSalesState();
}

class _NewSalesState extends State<NewSales> {
  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<List> _incomes;

  Future<Null> _addSales(String sale) async {
    final SharedPreferences prefs = await _prefs;
    List<String> incomes = prefs.getStringList("incomes") ?? [];
    incomes.add(sale);

    setState(() {
      _incomes = prefs.setStringList("incomes", incomes).then((bool success) {
        return incomes;
      });
    });
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BuildContext _scaffoldContext;

    Widget customForm = Container(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                autofocus: true,
                keyboardType: TextInputType.numberWithOptions(),
                decoration: const InputDecoration(
                  icon: Icon(Icons.attach_money), 
                  labelText: 'Enter Amount',
                ),
                controller: myController,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter an amount';
                  }
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: RaisedButton(
                        color: Color(0xFF0336FF),
                        onPressed: () {
                          if(_formKey.currentState.validate()){
                            _addSales(myController.text);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyHomePage()),
                            );
                          }
                        },
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('New Sales'),
      ),
      body: Builder(
        builder: (BuildContext context) {
          _scaffoldContext = context;

          return ListView(
            children: [customForm],
          );
        },
      ),
    );
  }
}
