import 'package:yo_te_cuido/screens/home/configuracion.dart';
import 'package:yo_te_cuido/screens/home/mapa/mapa.dart';
import 'package:yo_te_cuido/services/auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  int _selectedIndex = 1;
  List<Widget> _widgetOptions = <Widget>[
    Configuracion(),
    Mapa(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
            ),
            label: 'Configuracion',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.map_outlined,
            ),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.logout,
            ),
            label: 'Sign Out',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (int index) async {
          if (index != 2) {
            setState(() {
              _selectedIndex = index;
            });
          } else {
            await _auth.signOut();
          }
        },
        backgroundColor: Colors.green,
        selectedFontSize: 13.0,
        unselectedFontSize: 13.0,
        selectedItemColor: Colors.blueGrey[800],
        unselectedItemColor: Colors.white,
        unselectedLabelStyle:
            TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
        selectedLabelStyle: TextStyle(
            color: Colors.blueGrey,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat'),
        elevation: 7.0,
      ),
    );
  }
}
