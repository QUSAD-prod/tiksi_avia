import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;

class Fb {
  Fb();

  FirebaseAuth auth = FirebaseAuth.instance;
  DatabaseReference dbRef = FirebaseDatabase.instance.ref();

  bool isAuthenticated() {
    return auth.currentUser != null;
  }

  Future<String> signIn(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'ok';
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> signOut() async {
    try {
      await auth.signOut();
      return 'ok';
    } catch (e) {
      return 'error';
    }
  }

  Future<String> resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return 'ok';
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> sendData(Map<dynamic, dynamic> data, String date) async {
    ConnectivityResult internet = await Connectivity().checkConnectivity();
    if (internet == ConnectivityResult.mobile ||
        internet == ConnectivityResult.wifi) {
      try {
        dynamic temp = (await dbRef.child(date).get()).value;
        List<Map<dynamic, dynamic>> list = temp == null ? [] : List.from(temp);
        list.add(data);
        await dbRef.child(date).set(list);
        await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization':
                'key=AAAAQmNHfb8:APA91bHs7P7oyQdY6j_BWdWUYSB-tFFEvV3mUPkUOewO9qbJR4MrcnVCSmEbYu3hbIaOfclrscCdSIVDm6FEWdd_9Oyq1BGyf8iDPom7fydmtIyb88dzLapPMIkUH9WFJm59OzKu5G0d'
          },
          body: jsonEncode(
            {
              "to": "/topics/${getTopic(data['name'])}",
              "notification": {
                "title": "TiksiAvia",
                "body": "Был добавлен рейс ${data['name']}"
              },
              "direct_boot_ok": true
            },
          ),
        );
        return 'ok';
      } catch (e) {
        return e.toString();
      }
    } else {
      return 'network-request-failed';
    }
  }

  Future<String> updateData(
      Map<dynamic, dynamic> data, String date, int id) async {
    ConnectivityResult internet = await Connectivity().checkConnectivity();
    if (internet == ConnectivityResult.mobile ||
        internet == ConnectivityResult.wifi) {
      try {
        dbRef.child(date).update({id.toString(): data});
        await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization':
                'key=AAAAQmNHfb8:APA91bHs7P7oyQdY6j_BWdWUYSB-tFFEvV3mUPkUOewO9qbJR4MrcnVCSmEbYu3hbIaOfclrscCdSIVDm6FEWdd_9Oyq1BGyf8iDPom7fydmtIyb88dzLapPMIkUH9WFJm59OzKu5G0d'
          },
          body: jsonEncode({
            "to": "/topics/${getTopic(data['name'])}",
            "notification": {
              "title": "TiksiAvia",
              "body": "Рейс ${data['name']} был изменён"
            },
            "direct_boot_ok": true
          }),
        );
        return 'ok';
      } catch (e) {
        return e.toString();
      }
    } else {
      return 'network-request-failed';
    }
  }

  String getTopic(String name) {
    switch (name) {
      case "Тикси - Борогон":
        return '0';
      case "Борогон - Тикси":
        return '1';
      case "Тикси - Хара-Улах":
        return '2';
      case "Хара-Улах - Тикси":
        return '3';
      case "Тикси - Булун":
        return '4';
      case "Булун - Тикси":
        return '5';
      case "Тикси - Таймылыр":
        return '6';
      case "Таймылыр - Тикси":
        return '7';
      case "Тикси - Сиктях":
        return '8';
      case "Сиктях - Тикси":
        return '9';
      case "Тикси - Якутск":
        return '10';
      case "Якутск - Тикси":
        return '11';
      case "Тикси - Кюсюр":
        return '12';
      case "Кюсюр - Тикси":
        return '13';
      case "Тикси - Москва":
        return '14';
      case "Москва - Тикси":
        return '15';
      case "Тикси - Булун-Сиктях":
        return '16';
      case "Тикси - Борогон-Хара-Улах":
        return '17';
      default:
        return '';
    }
  }
}
