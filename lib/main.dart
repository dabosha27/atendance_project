import 'package:atendance_project/pages/Login_screen.dart';
import 'package:atendance_project/pages/Main_screen.dart';
import 'package:atendance_project/pages/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      routes: {
        'Main Screen' :(context)=> MainScreen(),
      },
      home:const Auth(),


    );
  }
}
