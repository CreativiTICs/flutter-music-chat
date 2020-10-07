import 'package:flutter/material.dart';

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:music_chat/services/chat_service.dart';
import 'package:music_chat/services/socket_service.dart';
import 'package:music_chat/services/auth_service.dart';

import 'package:music_chat/models/mensajes_response.dart';
import 'package:music_chat/widgets/chat_message.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();

  ChatService chatService;
  SocketServices socketServices;
  AuthService authService;

  List<ChatMessage> _messages = [];

  bool _estaEscribiendo = false;

  @override
  void initState() {
    super.initState();
    this.chatService = Provider.of<ChatService>(context, listen: false);
    this.socketServices = Provider.of<SocketServices>(context, listen: false);
    this.authService = Provider.of<AuthService>(context, listen: false);

    this.socketServices.socket.on('mensaje-personal', _escucharMensaje);

    _cargarHistorial(this.chatService.usuarioPara.uid);
  }

  void _cargarHistorial(String usuarioID) async {
    List<Mensaje> chat = await this.chatService.getChat(usuarioID);
    final history = chat.map((m) => new ChatMessage(
          texto: m.mensaje,
          uid: m.de,
          animationController: new AnimationController(
              vsync: this, duration: Duration(milliseconds: 0))
            ..forward(),
        ));

    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _escucharMensaje(dynamic payload) {
    ChatMessage message = new ChatMessage(
        texto: payload['mensaje'],
        uid: payload['de'],
        animationController: AnimationController(
            vsync: this, duration: Duration(milliseconds: 300)));
    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final charService = Provider.of<ChatService>(context);
    final usuarioPara = charService.usuarioPara;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        title: Column(
          children: [
            CircleAvatar(
              child: Text(
                usuarioPara.nombre.substring(0, 2),
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
              maxRadius: 14,
              backgroundColor: Colors.blue,
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              usuarioPara.nombre,
              style: TextStyle(fontSize: 12),
            )
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
                child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: _messages.length,
              itemBuilder: (_, i) => _messages[i],
              reverse: true,
            )),
            Divider(height: 1),
            Container(
              color: Colors.grey.withOpacity(0.1),
              child: _inputChat(),
            )
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Flexible(
                child: TextField(
              controller: _textController,
              onSubmitted: _handleSumit,
              onChanged: (texto) {
                setState(() {
                  if (texto.trim().length > 0) {
                    _estaEscribiendo = true;
                  } else {
                    _estaEscribiendo = false;
                  }
                });
              },
              decoration: InputDecoration.collapsed(hintText: 'Enviar Mensaje'),
              focusNode: _focusNode,
            )),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              child: Platform.isIOS
                  ? CupertinoButton(
                      child: Text('Enviar'),
                      onPressed: _estaEscribiendo
                          ? () => _handleSumit(_textController.text.trim())
                          : null,
                    )
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      child: IconTheme(
                        data: IconThemeData(color: Colors.blue),
                        child: IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          icon: Icon(Icons.send),
                          onPressed: _estaEscribiendo
                              ? () => _handleSumit(_textController.text.trim())
                              : null,
                        ),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  _handleSumit(String texto) {
    if (texto.length == 0) return;
    //Para Limpiar texto cuando se da enviar
    _textController.clear();
    //Para mantener el teclado abierto al darle enviar
    _focusNode.requestFocus();

    final newMessage = new ChatMessage(
      uid: authService.usuario.uid,
      texto: texto,
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 400)),
    );

    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {
      _estaEscribiendo = false;
    });

    this.socketServices.emit('mensaje-personal', {
      'de': this.authService.usuario.uid,
      'para': this.chatService.usuarioPara.uid,
      'mensaje': texto
    });
  }

  @override
  void dispose() {
    //Limpiar c/u de las instancias que tenemos en nuestro arreglo de mensajes
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    this.socketServices.socket.off('mensaje-personal');
    super.dispose();
  }
}
