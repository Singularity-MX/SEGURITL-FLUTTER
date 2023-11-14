import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../configBackend.dart';

class QRValidationScreen extends StatefulWidget {
  @override
  _QRValidationScreenState createState() => _QRValidationScreenState();
}

class _QRValidationScreenState extends State<QRValidationScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  String validationMessage = '';

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> validateQRCode(String token) async {
    ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Validando ' + token),
          ),
        );
    // Reemplaza con la URL de tu backend
    try {
      final response = await http.post(Uri.parse(
          ApiConfig.backendUrl + '/api/access/validate/$token'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final validationMessage = data['mensaje'];
        _showValidationDialog(validationMessage);
      } else {
        _showValidationDialog('Error en la solicitud al servidor');
      }
    } catch (e) {
      _showValidationDialog('Error de red');
    }
  }

  void _showValidationDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Resultado de Validación'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Validación de QR'),
      ),
      body: Column(
        children: [
          Expanded(
            child: QRView(
              key: qrKey,
              onQRViewCreated: (QRViewController controller) {
                this.controller = controller;
               controller.scannedDataStream.listen((scanData) {
  final qrCode = scanData.code ?? ''; // Si scanData.code es nulo, usa una cadena vacía
  validateQRCode(qrCode);
});

              },
            ),
          ),
          Text(validationMessage),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: QRValidationScreen(),
  ));
}
