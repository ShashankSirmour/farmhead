import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_ripper/service/Payment.dart';
import 'package:course_ripper/service/auth.dart';
import 'package:course_ripper/util/color/hex_code.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:sms/sms.dart';

class BillingPage extends StatefulWidget {
  final quan;

  const BillingPage({Key key, this.quan}) : super(key: key);
  @override
  _BillingPageState createState() => _BillingPageState();
}

class _BillingPageState extends State<BillingPage> {
  PaymentService _paymentService = PaymentService();
  AuthService _authService = AuthService();

  bool _promo = false;
  bool _isloading = false;
  Razorpay _razorpay;
  int _dayPayment = 40;
  int _promoCoupon = 0;
  int _totalPayment = 10;
  TextEditingController _textFieldController = TextEditingController();
  DocumentSnapshot _snapshot;

  @override
  void initState() {
    _dayPayment = 40 * widget.quan;
    _promo = false;
    _isloading = false;
    _totalPayment = _dayPayment;
    _razorpay = Razorpay();

    _paymentService.dayPayment().then((payment) {
      setState(() {
        print(payment);
        _dayPayment = payment * widget.quan;
        _totalPayment = _dayPayment;
      });
    });
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    SmsSender sender = new SmsSender();
    String address = "+916263441130";

    SmsMessage message = new SmsMessage(address,
        'Order need to deliver\n ${widget.quan.toString()} kg X tomato units\n please send it to q.no f1f nit raipur ');
    message.onStateChanged.listen((state) {
      if (state == SmsMessageState.Sent) {
        print("SMS is sent!");
      } else if (state == SmsMessageState.Delivered) {
        print("SMS is delivered!");
      }
    });
    sender.sendSms(message);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);

    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: <Widget>[
            Expanded(
                child: SingleChildScrollView(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AutoSizeText(
                    "BILLIING",
                    minFontSize: 15,
                    style: TextStyle(fontSize: 30),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  AutoSizeText(
                    "place order for payment gateway",
                    minFontSize: 10,
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: AutoSizeText(
                            widget.quan.toString() + "kg X tomato units",
                            minFontSize: 12,
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        Container(
                          child: Text("\u20B9$_dayPayment"),
                        )
                      ],
                    ),
                  ),
                  _promo
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    _isloading
                                        ? CircularProgressIndicator()
                                        : AutoSizeText(
                                            "Promo Coupon",
                                            minFontSize: 12,
                                            style: TextStyle(fontSize: 14),
                                          ),
                                    IconButton(
                                      icon: Icon(Icons.remove_circle_outline),
                                      onPressed: () {
                                        setState(() {
                                          _totalPayment = _dayPayment;
                                          _promo = false;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Text("$_promoCoupon % off"),
                              )
                            ],
                          ),
                        )
                      : FlatButton(
                          child: Text(
                            "Apply Promo",
                            style: TextStyle(
                              color: Colors.redAccent,
                            ),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Promo Code"),
                                content: TextField(
                                  controller: _textFieldController,
                                  keyboardType: TextInputType.text,
                                  decoration:
                                      InputDecoration(hintText: "Enter Code"),
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text("Apply"),
                                    onPressed: () async {
                                      if (_textFieldController.text.trim() ==
                                          "") return;
                                      _promoCoupon = 0;

                                      Navigator.pop(context);
                                      setState(() {
                                        _promo = true;
                                        _isloading = true;
                                      });
                                      String promo =
                                          _textFieldController.text == null
                                              ? ""
                                              : _textFieldController.text;

                                      _snapshot =
                                          await _paymentService.addPromo(promo);

                                      if (_snapshot != null) {
                                        _promoCoupon =
                                            int.parse(_snapshot.data['coupon']);

                                        double off = (_totalPayment *
                                            (_promoCoupon / 100));
                                        _totalPayment =
                                            _totalPayment - off.toInt();
                                        if (_totalPayment < 0)
                                          _totalPayment = 0;
                                      }

                                      setState(() {
                                        _isloading = false;
                                      });
                                    },
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: AutoSizeText(
                            "TOTAL",
                            minFontSize: 12,
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        Container(
                          child: Text("\u20B9$_totalPayment"),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )),
            Card(
              color: HexColor("#262626"),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(),
                  ),
                  Container(
                    height: 80,
                    padding: EdgeInsets.all(5),
                    child: InkWell(
                      splashColor: Colors.blue,
                      onTap: () {
                        int paid = _totalPayment;

                        if (paid <= 0) {
                          _authService.createSubscription(user, paid);
                        }

                        var options = {
                          'key': 'rzp_test_Q0i4xZcK1Lboat',
                          'amount': _totalPayment * 100,
                          'name': 'Farm-Hand',
                          'description': 'Get Primium app Subscription',
                          'prefill': {
                            'contact': '8888888888',
                            'email': 'test@razorpay.com',
                          }
                        };

                        try {
                          _razorpay.open(options);
                        } catch (e) {
                          print(e);
                          debugPrint(e);
                        }
                      },
                      child: Card(
                          child: Container(
                        padding: EdgeInsets.all(5),
                        height: double.infinity,
                        child: Row(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("\u20B9$_totalPayment"),
                                Text(
                                  "TOTAL",
                                  style: TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              "Place Order",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(Icons.keyboard_arrow_right)
                          ],
                        ),
                      )),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            )
          ],
        ));
  }
}
