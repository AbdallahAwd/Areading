import 'package:areading/views/settings/app.dart';
import 'package:areading/views/settings/user.dart';
import 'package:flutter/material.dart';

class Setting extends StatelessWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBarView(children: [
      Users(),
      const App(),
    ]);
  }
}
