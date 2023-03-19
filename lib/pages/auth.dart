import 'package:atendance_project/pages/Login_screen.dart';
import 'package:atendance_project/pages/Main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth extends StatelessWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((context, snapshot){
          if (snapshot.hasData){
            return MainScreen();
          }else{
            return LoginScreen();
          }
        }),
      ),
    );
  }
}
