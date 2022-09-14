import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

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
        data.addAll({"id": list.length});
        list.add(data);
        dbRef.child(date).set(list);
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
        return 'ok';
      } catch (e) {
        return e.toString();
      }
    } else {
      return 'network-request-failed';
    }
  }
}
