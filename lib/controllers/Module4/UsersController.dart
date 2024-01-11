import 'package:seguritl/models/Module1/RegistroModel.dart';
import 'package:seguritl/tools/password_hash.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../configBackend.dart';

// Para acceder a la dirección del backend:
String backendUrl = ApiConfig.backendUrl;

class UsersController {
  // Constructor que recibe la instancia de RegistroModel

  //enviar al backend
  String AddActJSON(String email, pass, type) {
    //crear el JSON
    Map<String, dynamic> jsonObject = {
      "tipo": type,
      "email": email,
      "password": pass
    };

    // Convertir el Map en una cadena JSON
    String formData = jsonEncode(jsonObject);

    return formData;
  }
}
