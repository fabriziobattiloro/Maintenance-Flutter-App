import 'package:ethos_app/Components/UnregisteredMachineAlert.dart';
import 'package:ethos_app/Services/database_command.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../DataTypes/Controllo.dart';
import 'ShowControl.dart';

final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
late QRViewController controller;

class QRCode extends StatefulWidget {
  const QRCode({Key? key}) : super(key: key);

  @override
  _QRCode createState() => _QRCode();
}

class _QRCode extends State<QRCode> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _onQRViewCreated(QRViewController controller) {
    controller.scannedDataStream.listen((scanData) async {
      controller.pauseCamera();
      bool presente = await isControlloPresente(scanData.code.toString());
      if (presente) {
        Controllo c = await getControllo(scanData.code.toString());
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => ControlView(controllo: c)));
      } else {
        await showDialog(
          context: context,
          builder: (context) {
            return UnregisteredMachineAlert(
              codice: scanData.code.toString(),
            );
          },
        );
        controller.resumeCamera();
      }

      // scanData.code è la stringa nel qr code

      // .then((value) => controller.resumeCamera());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scanner"),
        backgroundColor: Colors.red.shade900,
        automaticallyImplyLeading: false,
        leading: CloseButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.black54,
                Colors.black54,
              ],
            ),
          ),
          child: QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              overlayColor: const Color.fromRGBO(163, 0, 6, 0.5),
              borderColor: const Color.fromRGBO(163, 0, 6, 1),
              borderRadius: 15,
              borderLength: 130,
              borderWidth: 5,
            ),
          ),
        ),
      ),
    );
  }
}
