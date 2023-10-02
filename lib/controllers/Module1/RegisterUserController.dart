import 'package:glucontrol_app/models/Module1/RegistroModel.dart';
import 'package:glucontrol_app/tools/password_hash.dart';
import 'dart:convert';


class RegisterUserController {
  final RegistroModel registro;

  // Constructor que recibe la instancia de RegistroModel
  RegisterUserController(this.registro);


//enviarb json en el body


  // Método para realizar una acción, como mostrar un mensaje en la consola
  void hacerAlgo() {
    double imc = getIMC(registro.altura!, registro.peso!);


 String salt = "GlucontrolHash"; // Cambia esto por un valor secreto y único
  String hashedPassword = hashPassword(registro.password!, salt);
  


    print('Hola desde el controlador');
    print('Nombre: ${registro.nombre}');
    print('AP: ${registro.apellidoPaterno}');
    print('AM: ${registro.apellidoMaterno}');
    print('FECHA: ${registro.fechaNacimiento}');
    print('Altura: ${registro.altura}');
    print('Peso: ${registro.peso}');
    print('IMC: $imc'); // Imprimir el valor del IMC
    print('Email: ${registro.email}');
    print('Contraseña: ${registro.password}');
    print('Contraseña hasheada: $hashedPassword');


Map<String, dynamic> jsonObject = {
  "Nombre": registro.nombre,
  "ApellidoPaterno": registro.apellidoPaterno,
  "ApellidoMaterno": registro.apellidoMaterno,
  "FechaNacimiento": registro.fechaNacimiento,
  "Altura": registro.altura,
  "Peso": registro.peso,
  "IMC": imc,
  "Email": registro.email,
  "Password": hashedPassword
  };

  // Convertir el Map en una cadena JSON
  String jsonString = jsonEncode(jsonObject);

  print(jsonString);
    // Puedes realizar cualquier otra acción que necesites aquí
  }




double getIMC(double altura, double peso) {
    // Convertir la altura de centímetros a metros
    double alturaEnMetros =
        altura / 100; // Suponiendo que la altura está en centímetros

// Calcular el IMC
    double imc = peso / (alturaEnMetros * alturaEnMetros);

    return imc;
  }
}
