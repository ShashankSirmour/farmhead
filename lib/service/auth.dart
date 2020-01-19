import 'dart:convert';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:built_value/serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  Future<FirebaseUser> get getUser => _auth.currentUser();

  Stream<FirebaseUser> get user => _auth.onAuthStateChanged;

  Future<FirebaseUser> logIn(String email, String password) async {
    try {
      final FirebaseUser user = (await _auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;

      return user;
    } catch (e) {
      return null;
    }
  }

  Future<FirebaseUser> signIn(String email, String password) async {
    try {
      final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;

      return user;
    } catch (e) {
      return null;
    }
  }

  Future createSubscription(FirebaseUser user, int paid) async {
    DocumentReference reportRef =
        _db.collection("subscriptions").document(user.uid);

    String timeRequest;
    var timeData;
    var readableTime;
    var stdTime;

    var serializers =
        (Serializers().toBuilder()..add(Iso8601DateTimeSerializer())).build();

    var specifiedType = const FullType(DateTime);

    try {
      timeRequest =
          await http.read("http://worldtimeapi.org/api/timezone/Asia/Kolkata");

      timeData = jsonDecode(timeRequest);

      stdTime = DateTime.parse(serializers.deserialize(timeData["datetime"],
          specifiedType: specifiedType));

      readableTime = DateFormat.yMEd().add_jms().format(stdTime);
    } catch (e) {
      stdTime = DateTime.now().toString();
      readableTime = DateFormat.yMEd().add_jms().format(DateTime.now());
    }

    return reportRef.setData({
      'userId': user.uid,
      'time': readableTime,
      'stdTime': stdTime,
      'paid': paid,
    });
  }

  Future<void> signOut() {
    return _auth.signOut();
  }
}
