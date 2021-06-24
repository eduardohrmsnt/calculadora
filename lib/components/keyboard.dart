import 'package:flutter/material.dart';
import '../components/button.dart';
import '../components/button_row.dart';

class Keyboard extends StatelessWidget{

  final void Function(String) cb;

  Keyboard(this.cb);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      //Aqui se define os valores do botao para mostrar no display, com altura de 500
      height: 500,
      child: Column(
        children: <Widget>[
          //Cada buttonrow é uma sequencia de botoes
          ButtonRow([
            Button.big(text: 'AC', cb: cb),
            Button(text: '%', cb: cb),
            Button.dark(text: '/', cb: cb),
          ]),
          SizedBox(height: 1,),
          ButtonRow([
            Button(text: '7', cb: cb),
            Button(text: '8', cb: cb),
            Button(text: '9', cb: cb),
            Button.dark(text: 'x', cb: cb),
          ]),
          SizedBox(height: 1,),
          ButtonRow([
            Button(text: '4', cb: cb),
            Button(text: '5', cb: cb),
            Button(text: '6', cb: cb),
            Button.dark(text: '-', cb: cb),
          ]),
          SizedBox(height: 1,),
          ButtonRow([
            Button(text: '1', cb: cb),
            Button(text: '2', cb: cb),
            Button(text: '3', cb: cb),
            Button.dark(text: '+', cb: cb),
          ]),
          SizedBox(height: 1,),
          ButtonRow([
            Button.big(text: '0', cb: cb),
            Button(text: ',', cb: cb),
            Button.equals(text: '=', cb: cb),
          ])
        ],
      ),
    );
  }
}