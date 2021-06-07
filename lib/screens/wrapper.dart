import 'package:yo_te_cuido/models/user.dart';
import 'package:yo_te_cuido/screens/authenticate/authenticate.dart';
import 'package:yo_te_cuido/screens/authenticate/sign_in.dart';
import 'package:yo_te_cuido/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    print(user);

    // return either the Home or Authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}