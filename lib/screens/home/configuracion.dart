import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:yo_te_cuido/models/user.dart';
import 'package:yo_te_cuido/services/database.dart';

class Configuracion extends StatefulWidget {
  Configuracion({Key key}) : super(key: key);

  @override
  _ConfiguracionState createState() => _ConfiguracionState();
}

class _ConfiguracionState extends State<Configuracion> {
  String dropdownValue;
  String imei;
  int rango;
  bool isChecked = true;
  bool cambioRango = false;
  String latitud, longitud = '';

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    const _iconType = <IconData>[
      Icons.map_outlined,
      Icons.run_circle_outlined,
      Icons.volume_up_outlined,
      Icons.watch,
    ];
    List<String> _titleType = <String>[
      'Mapa',
      'Rango',
      'Notificaciones',
      'Reloj'
    ];
    List<Widget> _typeWidget = <Widget>[];

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            longitud = userData.rango_longitud;
            latitud = userData.rango_latitud;
            _typeWidget = [];
            _typeWidget.addAll([
              typeMap(userData.mapa),
              setRango(userData.rango),
              setSound(userData.notificacion),
              setWatch(userData.imei),
            ]);
            updateData() async {
              if (cambioRango) {
                cambioRango = false;
                longitud = userData.longitud;
                latitud = userData.latitud;
              }
              await DatabaseService(uid: user.uid).updateUserData(
                snapshot.data.latitud ?? snapshot.data.latitud,
                snapshot.data.longitud ?? snapshot.data.longitud,
                dropdownValue ?? snapshot.data.mapa,
                rango ?? snapshot.data.rango,
                imei ?? snapshot.data.imei,
                isChecked ?? snapshot.data.notificacion,
                longitud ?? snapshot.data.rango_longitud,
                latitud ?? snapshot.data.rango_latitud,
              );
            }

            updateData();

            return Scaffold(
              body: Container(
                  padding: EdgeInsets.only(left: 16, top: 25, right: 16),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        "Configuración",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Expanded(
                        child: ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: _iconType.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        _iconType[index],
                                        color: Colors.green,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        _titleType[index],
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    height: 15,
                                    thickness: 2,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  _typeWidget[index],
                                  SizedBox(
                                    height: 40,
                                  ),
                                ],
                              );
                            }),
                      ),
                    ],
                  )),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget typeMap(String userValue) {
    return DropdownButton<String>(
      value: userValue,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.grey[600],
      ),
      underline: Container(
        height: 2,
        color: Colors.grey[600],
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: <String>['Normal', 'Satelital', 'Hibrido']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget setWatch(String value) {
    return Container(
      width: 250,
      child: TextFormField(
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.grey[600],
        ),
        decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.never,
            icon: Icon(Icons.arrow_right),
            labelText: value,
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green))),
        onChanged: (val) {
          setState(() => imei = val);
        },
      ),
    );
  }

  Widget setRango(int n) {
    return Container(
      width: 250,
      child: TextFormField(
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.grey[600],
        ),
        decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.never,
            icon: Icon(Icons.arrow_right),
            labelText: n.toString(),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green))),
        onChanged: (val) {
          cambioRango = true;
          setState(() => rango = int.parse(val));
        },
      ),
    );
  }

  Widget setSound(bool check) {
    return Row(
      children: [
        Checkbox(
            checkColor: Colors.white,
            value: check,
            onChanged: (value) {
              setState(() {
                isChecked = value;
              });
            }),
        Text(
          'Sonido',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
