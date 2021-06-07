import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:yo_te_cuido/models/user.dart';
import 'package:yo_te_cuido/services/database.dart';
import 'dart:async';
import 'dart:math' as math;

class Mapa extends StatefulWidget {
  // Mapa({Key key}) : super(key: key);

  @override
  _MapaState createState() => _MapaState();
}

class _MapaState extends State<Mapa> {
  Completer<GoogleMapController> _controller = Completer();
  double _latitud;
  double _longitud;
  final num _RADIUS = 6371e3;
  double PI = math.pi;

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            // updateLocation(userData.latitud, userData.longitud);
            _latitud = double.parse(userData.latitud);
            _longitud = double.parse(userData.longitud);
            print(distanceBetweenTwoGeoPoints(
                LatLng(_latitud, _longitud), LatLng(_latitud, _longitud)));
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
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  void initLocation() async {
    final GoogleMapController controller = await _controller.future;
    print(_latitud);
    print(_longitud);
    if (controller != null) {
      controller.animateCamera(CameraUpdate.newCameraPosition(
          new CameraPosition(
              bearing: 192.8334901395799,
              target: LatLng(_latitud, _longitud),
              tilt: 0,
              zoom: 18.00)));
    }
  }

  double degToRadian(final double deg) => deg * (PI / 180.0);

  num distanceBetweenTwoGeoPoints(LatLng l1, LatLng l2, [num radius]) {
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

    return distance;
  }
}
