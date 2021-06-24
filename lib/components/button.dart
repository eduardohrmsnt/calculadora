import 'package:flutter/material.dart';

class Button extends StatelessWidget{
  //Constantes de cores utilizadas no teclado
  static const DEFAULT = Color.fromRGBO(247, 248, 252, 1);
  static const DARK = Color.fromRGBO(82, 113, 170, 1);
  static const ORANGE = Color.fromRGBO(254, 148, 46, 1);
  //Propriedades do botao
  final String text;
  final bool big;
  final Color color;
  final void Function(String) cb;

  //Construtores
  Button({
    @required this.text,
    this.big = false,
    this.color = DEFAULT,
    @required this.cb
  });
  Button.big({
    @required this.text,
    this.big = true,
    this.color = DEFAULT,
    @required this.cb,
  });

  Button.dark({
    @required this.text,
    this.big = false,
    this.color = DARK,
    @required this.cb,
  });

  Button.equals({
    @required this.text,
    this.big = false,
    this.color = ORANGE,
    @required this.cb,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: big ? 2 : 1,
      child: RaisedButton(
          color: this.color,
          child: Text(text,
          style: TextStyle(
            color: this.color != DEFAULT ? Colors.white : Color.fromRGBO(149, 162, 176, 1),
            fontSize: 32,
            fontWeight: FontWeight.w200
          ),),
          onPressed: () => cb(text),
      )
    );
  }
}