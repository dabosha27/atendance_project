import 'package:atendance_project/pages/QrCode_Screen.dart';
import 'Main_screen.dart';
import 'Report_Screen.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:flutter_launcher_icons/abs/icon_generator.dart';
import 'package:flutter_launcher_icons/android.dart';
import 'package:flutter_launcher_icons/constants.dart';
import 'package:flutter_launcher_icons/custom_exceptions.dart';
import 'package:flutter_launcher_icons/flutter_launcher_icons_config.dart';



class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int index =0;
  Widget build(BuildContext context) {
    List  screen  =[
      QrCodeScreen(),
      ReportScreen(),
    ];
    List <Widget >items =[
      Icon(Icons.qr_code_rounded ,size: 40 , color: Colors.white,),
      Icon(Icons.list, size: 40 ,color: Colors.white, ),
    ];

    return  Scaffold(
      extendBody: true,
      body:

      screen[index],



      bottomNavigationBar:CurvedNavigationBar(

        color: Colors.blue,
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colors.blue,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        height: 50,
        items: items,
        index: index,
        onTap: (index)=> setState(()=> this.index = index),
      ),
      backgroundColor: Colors.transparent,



    );


  }
}
