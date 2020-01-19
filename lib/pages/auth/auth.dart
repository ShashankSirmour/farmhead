import 'package:course_ripper/util/color/hex_code.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import '../../service/auth.dart';

GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _newUser = false;
  String _email;
  String _password;
  String _confirmPassword;
  AuthService _authService = AuthService();

  @override
  void initState() {
    _newUser = false;
    _authService.getUser.then((user) {
      if (user != null) {
        Navigator.pushReplacementNamed(context, '/main');
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: FractionalOffset(0.0, 0.4),
                end: FractionalOffset(0.9, 0.7),
                // Add one stop for each color. Stops should increase from 0 to 1
                stops: [0.1, 0.9],
                colors: [HexColor("#ff0a6c"), HexColor("#4a3cdb")],
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Center(
              child: ListView(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  headlinesWidget(),
                  buildForm(),
                  submitButtonWidget(context),
                  changeModeWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget headlinesWidget() {
    return Container(
      margin: EdgeInsets.only(left: 48.0, top: 22.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            _newUser ? "WELCOME DUDE!" : 'WELCOME BACK!',
            textAlign: TextAlign.left,
            style: TextStyle(
                letterSpacing: 3, fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          Container(
            margin: EdgeInsets.only(top: 48.0),
            child: Text(
              _newUser ? "Sign up \nto continue." : 'Log in \nto continue.',
              textAlign: TextAlign.left,
              style: TextStyle(
                letterSpacing: 3,
                fontSize: 32.0,
              ),
            ),
          )
        ],
      ),
    );
  }

  Form buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          emailTextFieldWidget(),
          passwordTextFieldWidget(),
          _newUser ? confirmPasswordTextFieldWidget() : Container(),
        ],
      ),
    );
  }

  Widget passwordTextFieldWidget() {
    return Container(
      margin: EdgeInsets.only(left: 32.0, right: 16.0),
      child: TextFormField(
        style: hintAndValueStyle,
        obscureText: true,
        decoration: new InputDecoration(
          fillColor: Color(0x3305756D),
          filled: true,
          contentPadding: new EdgeInsets.fromLTRB(40.0, 30.0, 10.0, 10.0),
          border: OutlineInputBorder(
            borderRadius: new BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          hintText: 'Password',
          hintStyle: hintAndValueStyle,
        ),
        onSaved: (String s) {
          _password = s;
        },
      ),
    );
  }

  Widget confirmPasswordTextFieldWidget() {
    return Container(
      margin: EdgeInsets.only(left: 52.0, right: 10.0),
      child: TextFormField(
        style: hintAndValueStyle,
        obscureText: true,
        decoration: new InputDecoration(
          fillColor: Color(0x3375744D),
          filled: true,
          contentPadding: new EdgeInsets.fromLTRB(40.0, 30.0, 10.0, 10.0),
          border: OutlineInputBorder(
            borderRadius: new BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          hintText: 'Confirm Password',
          hintStyle: hintAndValueStyle,
        ),
        onSaved: (String s) {
          _confirmPassword = s;
        },
      ),
    );
  }

  Widget emailTextFieldWidget() {
    return Container(
      margin: EdgeInsets.only(left: 16.0, right: 32.0, top: 32.0),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 15,
                spreadRadius: 0,
                offset: Offset(0.0, 16.0)),
          ],
          borderRadius: new BorderRadius.circular(12.0),
          gradient: LinearGradient(
              begin: FractionalOffset(0.0, 0.4),
              end: FractionalOffset(0.9, 0.7),
              stops: [
                0.2,
                0.9
              ],
              colors: [
                HexColor("#A32CDF").withOpacity(0.8),
                HexColor("#106aD2").withOpacity(0.8),
              ])),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        cursorColor: Colors.black,
        style: hintAndValueStyle,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(40.0, 30.0, 10.0, 10.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          hintText: 'Email',
          hintStyle: hintAndValueStyle,
        ),
        onSaved: (String s) {
          _email = s;
        },
      ),
    );
  }

  Widget submitButtonWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 32.0, top: 32.0),
      child: Row(
        children: <Widget>[
          InkWell(
            onTap: onSubmit,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 36.0, vertical: 16.0),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 15,
                        spreadRadius: 0,
                        offset: Offset(0.0, 32.0)),
                  ],
                  borderRadius: new BorderRadius.circular(36.0),
                  gradient: LinearGradient(
                      begin: FractionalOffset.centerLeft,
                      stops: [
                        0.2,
                        1
                      ],
                      colors: [
                        Color(0xff000000),
                        Color(0xff434343),
                      ])),
              child: Text(
                _newUser ? "SIGNUP" : 'LOGIN',
                style: TextStyle(
                  color: Color(0xffF1EA94),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget changeModeWidget() {
    return Container(
      margin: EdgeInsets.only(left: 48.0, top: 32.0),
      child: Row(
        children: <Widget>[
          Text(
            'Don\'t have an account?',
          ),
          FlatButton(
            padding: EdgeInsets.all(0),
            onPressed: () {
              setState(() {
                _newUser = _newUser == false ? true : false;
              });
            },
            child: Text(
              _newUser ? 'LogIn Now' : 'SignUp Now',
              style: TextStyle(
                color: Colors.black,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onSubmit() async {
    var error = false;
    FocusScope.of(context).requestFocus(FocusNode());
    _formKey.currentState.save();

    if (_email == null ||
        _password == null ||
        (_confirmPassword == null && _newUser == true)) {
      error = true;
    }

    if ((EmailValidator.validate(_email) != true) ||
        (_newUser == true && (_confirmPassword.compareTo(_password) != 0)))
      error = true;

    if (error) {
      print(error);
      return null;
    }

    FirebaseUser user = _newUser
        ? await _authService.signIn(_email, _password)
        : await _authService.logIn(_email, _password);

    if (user == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error !!!"),
            content: Text(
                "Some error happen please check your email andp assword. may be email alredy exist plaese try again."),
            actions: <Widget>[
              FlatButton(
                color: Colors.black,
                child: Text(
                  "Try again!",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    } else
      Navigator.pushReplacementNamed(context, '/main');

   
  }
}

final TextStyle hintAndValueStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 16.0,
);
