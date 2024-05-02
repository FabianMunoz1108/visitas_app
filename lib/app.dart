import 'package:flutter/cupertino.dart';
import 'package:visitas_app/screens/login.dart';

class VisitasApp extends StatelessWidget {
  const VisitasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'Visitas',
      home: Login(),
      theme: CupertinoThemeData(
        primaryColor: CupertinoColors.systemOrange,
        brightness: Brightness.light,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}