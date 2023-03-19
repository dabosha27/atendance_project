


import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:flutter_udid/flutter_udid.dart';
import 'Main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? email ;
  String? password;

  final _formKey = GlobalKey<FormState>();



  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }
  CollectionReference<Map<String, dynamic>> _deviceInfoCollection =
  FirebaseFirestore.instance.collection('deviceInfo');

  // Get the device's serial number
  Future<String> _getDeviceSerialNumber() async {
    String udid = await FlutterUdid.udid;
    print('serial number is ');
    print('Device UDID: $udid');
    return await FlutterUdid.udid;
  }

  // Check if the serial number already exists in the FireStore database
  Future<bool> _checkDevice( String serialNumber) async {
    final deviceInfoSnapshot = await _deviceInfoCollection
        .where('serialNumber', isEqualTo: serialNumber)
        .get();
    return deviceInfoSnapshot.docs.isNotEmpty;
  }
  Future<void> _addDevice( String serialNumber) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    await _deviceInfoCollection.add({

      'serialNumber': serialNumber,
      'lastUsed': timestamp,
    });
  }
  // Check if the student is allowed to log in on this device

  Future<bool> isAllowedToLogIn() async {
    String? deviceSerialNumber = await _getDeviceSerialNumber();
    if (deviceSerialNumber != null) {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('deviceInfo')
          .where('serialNumber', isEqualTo: deviceSerialNumber)
          .get();
      List<Map<String, dynamic>> query = querySnapshot.docs.map((e) => e.data()).toList();
      if (query.isNotEmpty) {
        return true;
      }
    }
    return false;
  }

  // Future<void> addDeviceSerialNumberToFirestore() async {
  //   String serialNumber='0';
  //   try {
  //     DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  //     if (Theme.of(context).platform == TargetPlatform.android) {
  //       AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  //       serialNumber = androidInfo.serialNumber;
  //     } else if (Theme.of(context).platform == TargetPlatform.iOS) {
  //       IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
  //       serialNumber = iosInfo.identifierForVendor!;
  //     }
  //     CollectionReference devices = FirebaseFirestore.instance.collection('students');
  //     await devices.doc('eYIaR0POOwRFIGdAlsmu').set({'serialNumber': serialNumber});
  //   } catch (e) {
  //     print('Error getting device serial number or adding to FireStore: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(

      padding: const EdgeInsets.symmetric(vertical: 0.1),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          extendBody: true,
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: FractionallySizedBox(
                        widthFactor: 0.8,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 50,
                            ),
                            Image.asset(
                              'assets/logo.png',
                              alignment: Alignment.topCenter,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      'LOGIN',
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Enter your Email',
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      // onChanged: (data){
                      //   password=data ;
                      // },

                      controller: _passwordController,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Enter your Password',
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap:() async {
                        String deviceId = await FlutterUdid.udid;

                        // Check if the student is allowed to log in on this device
                        bool isAllowed = await isAllowedToLogIn();
                        if ( isAllowed) {
                          try {
                            final credential = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim(),
                            );
                          } on FirebaseAuthException
                          catch (e) {
                            if (e.code == 'user-not-found') {
                              print('No user found for that email.');
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(
                                      'No user found for that email.')));
                            } else if (e.code == 'wrong-password') {
                              print('Wrong password provided for that user.');
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(
                                      'Wrong password provided for that user')));
                            }
                          }
                        }
                        else {
                          // Prevent the student from logging in on this device
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(
                                  'you may change your mobile please go to IT unit ')));
                        }

                      },



                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        width: 100,
                        height: 40,
                        child: Center(
                            child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

  }
}
