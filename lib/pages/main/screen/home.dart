import 'dart:ui';
import 'package:course_ripper/service/payment.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _textFieldController1 = TextEditingController();
  TextEditingController _textFieldController2 = TextEditingController();
  TextEditingController _textFieldController3 = TextEditingController();
  TextEditingController _textFieldController4 = TextEditingController();
  String _sellerName = "Raju Mohan";
  String _mob = "+916263441130";
  String _item = "TOMATO";
  String _price = "40Rs";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Edit Details"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextField(
                          controller: _textFieldController1,
                          keyboardType: TextInputType.text,
                          decoration:
                              InputDecoration(hintText: "Enter Your Name"),
                        ),
                        TextField(
                          controller: _textFieldController2,
                          keyboardType: TextInputType.text,
                          decoration:
                              InputDecoration(hintText: "Enter Mobile No."),
                        ),
                        TextField(
                          controller: _textFieldController3,
                          keyboardType: TextInputType.text,
                          decoration:
                              InputDecoration(hintText: "Enter Item Name"),
                        ),
                        TextField(
                          controller: _textFieldController4,
                          keyboardType: TextInputType.text,
                          decoration:
                              InputDecoration(hintText: "Enter Min Price"),
                        )
                      ],
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("Submit"),
                        onPressed: () async {
                          if (_textFieldController1.text.trim() == "" ||
                              _textFieldController2.text.trim() == "" ||
                              _textFieldController3.text.trim() == "" ||
                              _textFieldController4.text.trim() == "") return;

                          Navigator.pop(context);

                          String price = _textFieldController4.text == null
                              ? ""
                              : _textFieldController4.text;
                          PaymentService _paymentService = PaymentService();
                          bool done = await _paymentService.addPrice(price);

                          if (done != false) {
                            print("failed to update");
                          } else {
                            setState(() {
                              _sellerName = _textFieldController1.text.trim();
                              _mob = _textFieldController2.text.trim();
                              _item = _textFieldController3.text.trim();
                              _price = _textFieldController4.text.trim();
                            });
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        ),
        body: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.person,
                size: 90,
              ),
              SizedBox(
                height: 30,
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(
                      "Name : $_sellerName",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "Phone No : $_mob",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "Item : $_item",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "Min Price : $_price",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
