import 'dart:io';
import 'logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';


void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  home: HomePage(),
));


class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  String result = "Start Scan!";
  RestApi l = new RestApi();

  //this method will be called on scan of qr code
  Future _scanQR() async {
    try {
      String qrResult = "Tanuj is testing";
      //uncomment this line when testing on an actual device
      // String qrResult = await BarcodeScanner.scan();
      var res = l.postData(qrResult);
      print(res.toString());
      setState(() {
        result = qrResult;
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          result = "Camera permission was denied";
        });
      } else {
        setState(() {
          result = "Unknown error: $e";
        });
      }
    } on FormatException catch (e) {
      setState(() {
        result = "You have pressed back button before scanning";
      });
    } catch (e) {
      setState(() {
        result = "Unknown error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Barcode Scanner for ISS"),
      ),
      body: Center(
        child: Text(
          result,
          style: new TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.camera),
        label: Text("Scan"),
        onPressed: _scanQR,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
