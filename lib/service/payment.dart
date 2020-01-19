import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentService {
  final Firestore _db = Firestore.instance;

  Future<int> dayPayment() async {
    DocumentSnapshot _snapshot1, _snapshot2;
    double _payment = 10;
    DocumentReference reportRef = _db.collection("condition").document('data');
    DocumentReference reportRef2 = _db.collection("threshold").document('data');
    try {
      _snapshot1 = await reportRef.get();
      _snapshot2 = await reportRef2.get();

      _payment = double.parse(_snapshot1.data['proprice']) +
          double.parse(_snapshot1.data['timestamp']) *
              double.parse(_snapshot2.data['timestamp']) +
          double.parse(_snapshot1.data['weather']) *
              double.parse(_snapshot2.data['weather']) +
          double.parse(_snapshot2.data['weather']) /
              double.parse(_snapshot2.data['nofarm']) +
          double.parse(_snapshot1.data['holiday']) *
              double.parse(_snapshot2.data['holiday']) +
          double.parse(_snapshot1.data['timespan']) *
              double.parse((_snapshot2.data['timespan']));
    } catch (e) {
      _payment = 10;
    }

    return _payment.toInt();
  }

  Future<DocumentSnapshot> addPromo(String promo) async {
    DocumentSnapshot _snapshot;
    DocumentReference reportRef = _db.collection("promo").document(promo);
    try {
      _snapshot = await reportRef.get();
    } catch (e) {
      print("error");
      _snapshot = null;
    }

    return _snapshot;
  }

  Future<bool> addPrice(String price) async {
    DocumentSnapshot _snapshot;
    DocumentReference reportRef = _db.collection("farmer").document("data");
    try {
      _snapshot = await reportRef.get();
    } catch (e) {
      print("error");
      _snapshot = null;
      return false;
    }

    return true;
  }
}
