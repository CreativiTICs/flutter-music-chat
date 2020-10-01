import 'package:flutter/material.dart';

import 'package:music_chat/widgets/logo.dart';
import 'package:music_chat/widgets/labels.dart';
import 'package:music_chat/widgets/custom_input.dart';
import 'package:music_chat/widgets/boton_azul.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Logo(titulo: 'CHAT'),
              _Form(),
              Labels(
                  ruta: 'register',
                  texto1: '¿No tienes Cuenta?',
                  texto2: 'Crea una Ahora'),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  'Términos y Condiciones de Uso',
                  style: TextStyle(fontWeight: FontWeight.w200),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}

class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Correo',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'Contraseña',
            textController: passCtrl,
            isPassword: true,
          ),
          BotonAzul(
            text: 'Ingresar',
            onPressed: () {
              print(emailCtrl.text);
              print(passCtrl.text);
            },
          )
        ],
      ),
    );
  }
}
