import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:music_chat/services/auth_service.dart';

class ChatMessage extends StatelessWidget {
  final String texto;
  final String uid;
  final AnimationController animationController;

  const ChatMessage(
      {Key key,
      @required this.texto,
      @required this.uid,
      @required this.animationController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authServices = Provider.of<AuthService>(context, listen: false);

    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(
            parent: animationController, curve: Curves.bounceIn),
        child: Container(
          child: this.uid == authServices.usuario.uid
              ? _myMessage()
              : _notMyMessage(),
        ),
      ),
    );
  }

  Widget _myMessage() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.only(bottom: 5, left: 50, right: 5),
        child: Text(
          this.texto,
          style: TextStyle(color: Colors.white),
        ),
        decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(1),
                topLeft: Radius.circular(1),
                bottomLeft: Radius.circular(20),
                topRight: Radius.circular(20))),
      ),
    );
  }

  Widget _notMyMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.only(bottom: 5, left: 5, right: 50),
        child: Text(
          this.texto,
          style: TextStyle(color: Colors.white),
        ),
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20),
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(1),
                topRight: Radius.circular(1))),
      ),
    );
  }
}
