import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final String titulo;

  const Logo({Key key, @required this.titulo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      width: 300,
      margin: EdgeInsets.only(top: 40),
      child: Column(
        children: [
          Image(image: AssetImage('assets/Creativitics.png')),
          SizedBox(
            height: 10,
          ),
          Text(
            this.titulo,
            style: TextStyle(fontSize: 25),
          )
        ],
      ),
    ));
  }
}
