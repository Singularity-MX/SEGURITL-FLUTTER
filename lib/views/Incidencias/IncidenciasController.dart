import 'package:glucontrol_app/models/Module1/RegistroModel.dart';
import 'package:glucontrol_app/tools/password_hash.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../configBackend.dart';

// Para acceder a la dirección del backend:
String backendUrl = ApiConfig.backendUrl;

class ActivitiesController {
  // Constructor que recibe la instancia de RegistroModel


  //enviar al backend
  String AddActJSON(String tipo, subtipo, comentario, foto, user_id) {
    //crear el JSON
    Map<String, dynamic> jsonObject = {
      "tipo": tipo,
    "subtipo":subtipo,
    "comentario": comentario,
    "foto": foto,
    "user_id": user_id
    };

    // Convertir el Map en una cadena JSON
    String formData = jsonEncode(jsonObject);

    return formData;
  }
}
