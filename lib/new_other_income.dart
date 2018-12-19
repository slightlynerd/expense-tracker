import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

class NewOtherIncome extends StatefulWidget {
  @override
  _NewOtherIncomeState createState() => _NewOtherIncomeState();
}

class _NewOtherIncomeState extends State<NewOtherIncome> {

  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<List> _otherIncomes;

  Future<Null> _addOtherIncome(String sale) async {
    final SharedPreferences prefs = await _prefs;
    List<String> otherIncomes = prefs.getStringList("otherIncomes") ?? [];
    otherIncomes.add(sale);

    setState(() {
      _otherIncomes = prefs.setStringList("otherIncomes", otherIncomes).then((bool success) {
        return otherIncomes;
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
                    icon: Icon(Icons.attach_money), labelText: 'Enter Amount'),
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
                        color: Color(0xFF03DAC5),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _addOtherIncome(myController.text);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyHomePage()),
                            );
                          }
                        },
                        child: Icon(
                          Icons.arrow_forward,
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
        title: Text('Other Income'),
      ),
      body: Builder(
        builder: (BuildContext context) {
          _scaffoldContext = context;

          return ListView(
            children: [
              customForm
            ],
          );
        },
      ),
    );
  }

}