import 'package:course_ripper/pages/auth/auth.dart';
import 'package:course_ripper/pages/billing/billing.dart';
import 'package:course_ripper/pages/main/main.dart';
import 'package:course_ripper/service/auth.dart';
import 'package:course_ripper/util/color/hex_code.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(
          value: AuthService().user,
        )
      ],
      child: MaterialApp(
        theme: ThemeData(
            primaryColor: HexColor("#262626"),
            accentColor: Colors.black,
            appBarTheme: AppBarTheme()),
        debugShowCheckedModeBanner: false,
        routes: {
         
          '/': (context) => MainPage(),
          '/cart': (context) {
            return BillingPage(
              quan: ModalRoute.of(context).settings.arguments,
            );
          },
        },
      ),
    );
  }
}
