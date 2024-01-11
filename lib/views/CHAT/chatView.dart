import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:seguritl/configBackend.dart';
import 'package:seguritl/views/Incidencias/IncidenciasController.dart';
import 'package:shared_preferences/shared_preferences.dart';

//body: jsonEncode({'sender': 'User', 'text': text}),

class Message {
  final String sender;
  final String text;

  Message({required this.sender, required this.text});
}

void main() {
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  State createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  List<ChatMessage> _messages = <ChatMessage>[];

  final TextEditingController _textController = TextEditingController();
  List<dynamic> JSON = [];

  Future<void> sendMessage(String text) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');

      final response = await http.post(
        Uri.parse(backendUrl + '/api/chat/add'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'user_id': userId, 'mensaje': text}),
      );
    } catch (e) {
      print('Error al enviar los datos al backend: $e');
      // Mostrar un SnackBar con el mensaje de error de conexión
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'No se pudo conectar al backend. Verifica tu conexión de red o inténtalo más tarde.'),
        ),
      );
    }
  }

  void getMenssages() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? emailUser = prefs.getString('emailUser');
      final response =
          await http.get(Uri.parse(ApiConfig.backendUrl + '/api/chat/all'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        List<ChatMessage> messages = jsonData.map<ChatMessage>((data) {
          print("Mensaje: ${data['mensaje']}");
          if (data['email'] == emailUser) {
            data['email'] = 'Tú';
          }
          return ChatMessage(
            user_id: data['email'],
            text: data['mensaje'],
            id: data['id'],
            animationController: AnimationController(
              duration: Duration(milliseconds: 500),
              vsync: this,
            ),
          );
        }).toList();

        messages.sort((a, b) => b.id.compareTo(a.id)); // Invertir la lista aquí

        setState(() {
          _messages.addAll(messages);
        });

        for (ChatMessage message in messages) {
          message.animationController.forward();
        }
      } else {
        print('Error al obtener mensajes: ${response.statusCode}');
      }
    } catch (error) {
      print('Error en la solicitud: $error');
    }
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    ChatMessage message = ChatMessage(
      user_id: 'Tú', // Cambia 'User' por el valor adecuado de user_id
      text: text,
      id: 100,
      animationController: AnimationController(
        duration: Duration(milliseconds: 500),
        vsync: this,
      ),
    );
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
    sendMessage(text);
  }

  @override
  void initState() {
    super.initState();
    // Llamar a la función para obtener alimentos cuando se carga la pantalla

    getMenssages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat App'),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              reverse: true, // Establecer reverse a true
              padding: EdgeInsets.all(8.0),
              itemBuilder: (_, int index) => _messages[index],
              itemCount: _messages.length,
            ),
          ),
          Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Colors.blue),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(
              12.0), // Ajusta el valor según sea necesario
        ),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration: InputDecoration.collapsed(
                  hintText: 'Enviar un mensaje',
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () => _handleSubmitted(_textController.text),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}

class ChatMessage extends StatelessWidget {
  final String user_id;
  final String text;
  final AnimationController animationController;
  int id; // Agregar el campo id

  ChatMessage({
    required this.user_id,
    required this.text,
    required this.animationController,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOut,
      ),
      axisAlignment: 0.0,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                child: Text(user_id.substring(0, 1)),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(user_id, style: Theme.of(context).textTheme.subtitle1),
                  Container(
                    margin: EdgeInsets.only(top: 5.0),
                    child: Text(text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
