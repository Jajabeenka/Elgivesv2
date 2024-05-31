import 'package:flutter/cupertino.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';

import '../provider/donation_provider.dart';

class ScanQRCode extends StatefulWidget {
  const ScanQRCode({Key? key}) : super(key: key);

  @override
  _ScanQRCodeState createState() => _ScanQRCodeState();
}

class _ScanQRCodeState extends State<ScanQRCode> {
  String qrResult = 'Scan QR Code';
  bool isScanning = false;

  Future<void> scanQR() async {
    setState(() {
      isScanning = true;
    });

    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#FF3B30', // Use Cupertino red color
        'Cancel',
        true,
        ScanMode.QR,
      );
      if (!mounted) return;
      setState(() {
        qrResult = qrCode != '-1' ? qrCode : 'Scan Cancelled';
        if (qrCode != '-1') {
          extractDonationId(qrCode);
        }
      });
    } catch (e) {
      setState(() {
        qrResult = 'Failed to read QR Code';
      });
    } finally {
      setState(() {
        isScanning = false;
      });
    }
  } 

  void extractDonationId(String qrCode) {
  RegExp donationIdRegExp = RegExp(r"donationId: (\d+)");
  Match? match = donationIdRegExp.firstMatch(qrCode);

  if (match != null) {
    String donationId = match.group(1)!;
    setState(() {
      qrResult = donationId;
    });
    updateDonationStatus(donationId);
  } else {
    setState(() {
      qrResult = 'No Donation ID Found';
    });
  }
}
 
 void updateDonationStatus(String donationId) {
    final donationProvider = Provider.of<DonationProvider>(context, listen: false);
    donationProvider.editStatus(int.parse(donationId), 'Completed');
    print("Donation status updated for ID: $donationId"); 
  }


  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('QR Code Scanner'),
        backgroundColor: CupertinoColors.systemGrey,
        border: Border(bottom: BorderSide.none),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    CupertinoColors.systemGrey4,
                    CupertinoColors.systemGrey6,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isScanning ? CupertinoColors.systemYellow : CupertinoColors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: CupertinoColors.systemGrey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    qrResult,
                    style: TextStyle(
                      color: CupertinoColors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 30),
                CupertinoButton(
                  onPressed: isScanning ? null : scanQR,
                  child: Text('Scan Code'),
                  color: CupertinoColors.activeBlue,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  borderRadius: BorderRadius.circular(8),
                ),
                if (isScanning)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: CupertinoActivityIndicator(
                      radius: 15,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
