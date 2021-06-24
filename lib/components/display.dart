import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class Display extends StatelessWidget{
  final String text;

  Display(this.text);

  @override
  Widget build(BuildContext context) {
    return  Expanded(
      flex:1,
      //Aqui esta sendo criado o display com algumas estilizacoes e espacamentos
      child:Container(
        color: Color.fromRGBO(228, 232, 241, 1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children:<Widget>[
              Padding(
                padding: const EdgeInsets.all((8.0)),
                child:AutoSizeText(
                    text,
                    minFontSize: 20,
                  maxFontSize: 80,
                  maxLines: 1,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontWeight: FontWeight.w100,
                    decoration: TextDecoration.none,
                    fontSize: 70,
                    color: Color.fromRGBO(131, 149, 173, 1)
                  )
                ),
              )]
            ),
      ),
    );
  }

}