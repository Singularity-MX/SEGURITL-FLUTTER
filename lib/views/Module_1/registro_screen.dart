import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegistroScreen extends StatefulWidget {
  @override
  _RegistroScreenState createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _apellidoPaternoController = TextEditingController();
  TextEditingController _apellidoMaternoController = TextEditingController();
  TextEditingController _edadController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _contrasenaController = TextEditingController();
  TextEditingController _confirmarContrasenaController =
      TextEditingController();

  Future<void> _enviarRegistro() async {
    final url = Uri.parse('http://localhost:3000/api/registro');
    final response = await http.post(
      url,
      body: {
        'Nombre': _nombreController.text,
        'apellidoPaterno': _apellidoPaternoController.text,
        'apellidoMaterno': _apellidoMaternoController.text,
        'edad': _edadController.text,
        'email': _emailController.text,
        'contrasena': _contrasenaController.text,
      },
    );

    if (response.statusCode == 201) {
      // Registro exitoso, puedes manejar la respuesta aquí
      print('Usuario registrado exitosamente');
    } else {
      // Ocurrió un error al registrar al usuario, maneja el error aquí
      print('Error al registrar al usuario');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Por favor, ingresa tu nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _apellidoPaternoController,
                decoration: InputDecoration(labelText: 'Apellido Paterno'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Por favor, ingresa tu apellido paterno';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _apellidoMaternoController,
                decoration: InputDecoration(labelText: 'Apellido Materno'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Por favor, ingresa tu apellido materno';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _edadController,
                decoration: InputDecoration(labelText: 'Edad'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Por favor, ingresa tu edad';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Por favor, ingresa tu email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _contrasenaController,
                decoration: InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Por favor, ingresa una contraseña';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _confirmarContrasenaController,
                decoration: InputDecoration(labelText: 'Confirmar Contraseña'),
                obscureText: true,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Por favor, confirma tu contraseña';
                  }
                  if (value != _contrasenaController.text) {
                    return 'Las contraseñas no coinciden';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _enviarRegistro();
                  }
                },
                child: Text('Registrarse'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
