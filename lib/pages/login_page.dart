import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:music_chat/services/auth_service.dart';
import 'package:music_chat/services/socket_service.dart';

import 'package:music_chat/helpers/mostrar_alerta.dart';

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
    final authServices = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketServices>(context);
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
            onPressed: authServices.autenticando
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    final loginOk = await authServices.login(
                        emailCtrl.text.trim(), passCtrl.text.trim());
                    if (loginOk) {
                      //navegar a otra pantalla y conectar al socket server
                      socketService.connect();
                      Navigator.pushReplacementNamed(context, 'usuarios');
                    } else {
                      //Mostra Alerta
                      mostrarAlerta(context, 'Login incorrecto',
                          'Revise sus credenciales nuevamente');
                    }
                  },
          )
        ],
      ),
    );
  }
}
