import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:barcode_scanner/barcode_scanner.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:qr_flutter/qr_flutter.dart';

import 'package:scan/scan.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isQrEnabled = false;
  final GlobalKey qrKey = GlobalKey();
  Barcode? result;
  String? resultString;
  QRViewController? controller;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          // backgroundColor: Colors.tealAccent,
          appBar: AppBar(
            // backgroundColor: Colors.tealAccent,// Colors.greenAccent.withOpacity(0.5),
            actions: const [
              Padding(
                padding: EdgeInsets.all(17),
                child: Text(
                  "Message",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.all(17),
                child: Text(
                  "Profile",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          body: Stack(
            children: [
              (isQrEnabled)?QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
              ):Center(
                child: Text("Returned String is: ${resultString.toString()}"),
              ),
              Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                      onTap: (){
                        setState(() {
                          isQrEnabled = true;
                        });
                      },
                      child: const Icon(Icons.camera_alt)),
                  const SizedBox(width: 20,),
                  InkWell(
                    onTap: () async {
                      final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
                      String? res = await Scan.parse(image!.path);
                      if(res != null) {
                        setState(() {
                          resultString = res;
                        });
                      }
                    },
                      child: const Icon(Icons.photo))
                ],
              ))
            ],
          )
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        resultString = result?.code.toString();
        isQrEnabled = false;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
