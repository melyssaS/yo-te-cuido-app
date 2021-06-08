import 'package:yo_te_cuido/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference brewCollection =
      Firestore.instance.collection('brews');

  Future<void> updateUserData(
      String latitud,
      String longitud,
      String mapa,
      int rango,
      String imei,
      bool notificacion,
      String rango_longitud,
      String rango_latitud) async {
    return await brewCollection.document(uid).setData({
      'latitud': latitud,
      'longitud': longitud,
      'mapa': mapa,
      'rango': rango,
      'imei': imei,
      'notificacion': notificacion,
      'rango_longitud': rango_longitud,
      'rango_latitud': rango_latitud
    });
  }

  // user data from snapshots
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        latitud: snapshot.data['latitud'],
        longitud: snapshot.data['longitud'],
        mapa: snapshot.data['mapa'],
        rango: snapshot.data['rango'],
        imei: snapshot.data['imei'],
        notificacion: snapshot.data['notificacion'],
        rango_longitud: snapshot.data['rango_longitud'],
        rango_latitud: snapshot.data['rango_latitud']);
  }

  // get user doc stream
  Stream<UserData> get userData {
    return brewCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }
}
