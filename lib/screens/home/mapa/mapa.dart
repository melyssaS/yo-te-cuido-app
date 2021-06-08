import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:yo_te_cuido/models/user.dart';
import 'package:yo_te_cuido/services/database.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:yo_te_cuido/main.dart';

class Mapa extends StatefulWidget {
  // Mapa({Key key}) : super(key: key);

  @override
  _MapaState createState() => _MapaState();
}

class _MapaState extends State<Mapa> {
  Completer<GoogleMapController> _controller = Completer();
  double _latitud;
  double _longitud;
  double _latitudR;
  double _longitudR;
  final num _RADIUS = 6371e3;
  double PI = math.pi;
  Set<Circle> circles;

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            _latitud = double.parse(userData.latitud);
            _longitud = double.parse(userData.longitud);
            circles = null;
            if (double.parse(userData.rango_latitud, (e) => null) != null) {
              _latitudR = double.parse(userData.rango_latitud);
              _longitudR = double.parse(userData.rango_longitud);
              distanceBetweenTwoGeoPoints(LatLng(_latitud, _longitud),
                  LatLng(_latitudR, _longitudR), userData.rango);
              print('hola');
              circles = Set.from([
                Circle(
                    circleId: CircleId('Zona Segura'),
                    center: LatLng(_latitudR, _longitudR),
                    radius: userData.rango.toDouble(),
                    strokeColor: Colors.blue,
                    strokeWidth: 5,
                    fillColor: Color.fromRGBO(0, 192, 255, 0.5))
              ]);
            }
            initLocation();
            return GoogleMap(
                mapType: MapType.hybrid,
                initialCameraPosition: CameraPosition(
                  target: LatLng(_latitud, _longitud),
                  zoom: 18.0,
                ),
                markers: Set.of([
                  Marker(
                      markerId: MarkerId('Posicion'),
                      position: LatLng(_latitud, _longitud))
                ]),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                circles: circles);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  void initLocation() async {
    final GoogleMapController controller = await _controller.future;
    if (controller != null) {
      controller.animateCamera(CameraUpdate.newCameraPosition(
          new CameraPosition(
              bearing: 192.8334901395799,
              target: LatLng(_latitud, _longitud),
              tilt: 0,
              zoom: 18.00)));
    }
  }

  void scheduleAlarm() async {
    var scheduledNotificationDateTime =
        DateTime.now().add(Duration(seconds: 10));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      'Channel for Alarm notification',
      icon: 'logo',
      sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
      largeIcon: DrawableResourceAndroidBitmap('logo'),
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
        sound: 'a_long_cold_sting.wav',
        presentAlert: true,
        presentBadge: true,
        presentSound: true);

    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.schedule(
        0,
        'ATENCION',
        ' Se ha saido de la zona segura !',
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }

  double degToRadian(final double deg) => deg * (PI / 180.0);

  void distanceBetweenTwoGeoPoints(LatLng l1, LatLng l2, int rango,
      [num radius]) {
    radius = radius ?? _RADIUS;
    num R = radius;
    num l1LatRadians = degToRadian(l1.latitude);
    num l1LngRadians = degToRadian(l1.longitude);
    num l2LatRadians = degToRadian(l2.latitude);
    num l2LngRadians = degToRadian(l2.longitude);
    num latRadiansDiff = l2LatRadians - l1LatRadians;
    num lngRadiansDiff = l2LngRadians - l1LngRadians;

    num a = math.sin(latRadiansDiff / 2) * math.sin(latRadiansDiff / 2) +
        math.cos(l1LatRadians) *
            math.cos(l2LatRadians) *
            math.sin(lngRadiansDiff / 2) *
            math.sin(lngRadiansDiff / 2);
    num c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    num distance = R * c;
    print(distance);
    if (rango < distance) {
      print('oh no');
      scheduleAlarm();
    }
  }
}
