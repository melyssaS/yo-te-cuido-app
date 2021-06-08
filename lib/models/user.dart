class User {
  final String uid;

  User({this.uid});
}

class UserData {
  final String uid;
  final String longitud;
  final String latitud;
  String mapa;
  int rango;
  String imei;
  bool notificacion;
  String rango_longitud;
  String rango_latitud;

  UserData(
      {this.uid,
      this.latitud,
      this.longitud,
      this.mapa,
      this.rango,
      this.imei,
      this.notificacion,
      this.rango_longitud,
      this.rango_latitud});
}
