import 'package:yo_te_cuido/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference brewCollection =
      Firestore.instance.collection('brews');

  Future<void> updateUserData(
      String latitud, String longitud, int rango, String imei) async {
    return await brewCollection.document(uid).setData({
      'latitud': latitud,
      'longitud': longitud,
      'rango': rango,
      'imei': imei
    });
  }

  // user data from snapshots
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        longitud: snapshot.data['longitud'],
        latitud: snapshot.data['latitud'],
        rango: snapshot.data['rango'],
        imei: snapshot.data['imei']);
  }

  // get user doc stream
  Stream<UserData> get userData {
    return brewCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }
}
