import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({Key? key}) : super(key: key);

  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Stack(
                  children: [
                    QRView(
                      key: qrKey,
                      onQRViewCreated: _onQRViewCreated,
                    ),
                    Center(
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 4,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            child: Container(
              // margin: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(left: 330, top: 30),
              color: Colors.transparent,

              child: IconButton(
                  onPressed: () async {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 40,
                  )
/*
                child: FutureBuilder(
                  future: controller?.getFlashStatus(),
                  builder: (context, snapshot) {


                   // return Container(child: Text('Flash: ${snapshot.data}'));
                  },*/
                  ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    setState(() {
      controller.resumeCamera();

      controller.scannedDataStream.listen((scanData) async {
        controller.pauseCamera();
        //    controller.resumeCamera();
        //  controller.pauseCamera();
        String data = scanData.code.toString();
        Navigator.pop(context, data);
      });
    });
  }
}
