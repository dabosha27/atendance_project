import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:toast/toast.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';


class QrCodeScreen extends StatefulWidget {
  @override
  State<QrCodeScreen> createState() => _QrCodeScreenState();
}



  // Toast.show('Please Scan again',
  //     duration: 2, gravity: Toast.bottom);




class _QrCodeScreenState extends State<QrCodeScreen> {
  String _qrCode = '';
  final   classAAttendanceCollection = FirebaseFirestore.instance.collection('attendance');
  Future<void> _scanQRCode() async {
    final qrCode = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666',
      'Cancel',
      true,
      ScanMode.QR,
    );

    setState(() {
      _qrCode = qrCode;
    });

    // Retrieve the student document from the attendance collection
    final QuerySnapshot querySnapshot = await classAAttendanceCollection.where('qrCode', isEqualTo: _qrCode).get();
    final DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
    final isPresent = true;
    // Update the attendance record based on whether the student is present or absent
    if ( isPresent) {
      documentSnapshot.reference.update({'attendanceDays': documentSnapshot['attendanceDays'] + 1});
    } else {
      documentSnapshot.reference.update({'absenceDays': documentSnapshot['absenceDays'] + 1});
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,

      body:SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

               SizedBox(
                 height: 100,
               ),
              Container(
                margin: EdgeInsets.only(top: 20, bottom: 0),
                child: Text(
                  "Attend new class",
                  style: TextStyle(fontSize: 25, color: Colors.black),
                ),
              ),
              Container(
                width: 300,
                height: 350,
                child: Image.asset("assets/scan.png"),
              ),
              Container(
                width: 250,
                height: 90,
                child: ElevatedButton(
                  onPressed: _scanQRCode,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(
                        CupertinoIcons.barcode_viewfinder,
                        color: Colors.white,
                        size: 30,
                        ),
                      Text(
                        "Scan to attend class",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      )
                    ],
                  ),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    )),
                    backgroundColor: MaterialStateProperty.all(
                        Colors.pinkAccent.withOpacity(0.5)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );



  }
}
