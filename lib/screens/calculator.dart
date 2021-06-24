
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../components/display.dart';
import '../components/keyboard.dart';
import '../models/memory.dart';

class Calculator extends StatefulWidget{
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  final Memory memory = Memory();
  List _toDoList = [];

  _onPressed(String command){
    setState(() {
      memory.applyCommand(command);
    });
  }

  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);

    return MaterialApp(
      home: Scaffold (
              drawer: Container(
                  color: Colors.white,
                  width: 280,
                  child:Column(
                    children: [Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          //para mostrar a lista sempre atualizada utilizasse o Streambuilder
                          //pois sempre que tiver um novo registro ira executar oque esta no "stream"
                          stream: fireStore.collection('history').snapshots(),
                          builder: (context, snapshot){
                            switch(snapshot.connectionState){
                              //Caso esteja carregando ou nao tenha conexao mostrara um icone de carregamento
                              case ConnectionState.none:
                              case ConnectionState.waiting:
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              default:
                                //Se os dados estiverem carregados transformara os resultados numa lista
                                List<DocumentSnapshot> docs =
                                snapshot.data.docs.toList();

                                return ListView.builder(
                                  //Montara a lista no modo "reverse" para mostrar sempre o ultimo registro
                                  itemCount: docs.length,
                                  reverse: true,
                                  itemBuilder: (context, index){

                                    return ListTile(
                                      //Se existe registro na posicao mostrara o valor concatenado com a operacao e o outro valor digitado
                                      title: Text(docs[index].exists ? docs[index].data()['value1'].toString() +
                                          docs[index].data()['operation'].toString() +
                                          docs[index].data()['value2'].toString() : '',
                                        style: TextStyle(
                                          fontSize: 20,
                                          height: 3.0,
                                          color: Color.fromRGBO(131, 149, 173, 1),
                                          wordSpacing: 5,

                                        ),
                                      ),
                                      //Se existe registro na posicao mostrara o simbolo de igual com o resultado logo ao lado
                                      subtitle: Text(docs[index].exists ? '=' + docs[index].data()['result'].toString() : '', style: TextStyle( color: Color.fromRGBO(254, 148, 46, 1)),),
                                    );

                                  },
                                //Definindo o espacamento entre a lista e o botao
                                padding: EdgeInsets.only(bottom: 30),
                                );

                            }
                          },
                        )

                    ),

                    RaisedButton(
                      //Ao clicar no botao deletara todos os registros do firebase
                      onPressed: () =>{
                        fireStore.collection('history').get().then((snapshot){
                          for (DocumentSnapshot ds in snapshot.docs){
                            ds.reference.delete();
                          }
                        })
                      },
                      color: Color.fromRGBO(254, 148, 46, 1),
                      child: Text('Limpar Historico',
                      style: TextStyle(
                        color: Colors.white
                    ),),)],
                  )

              ),
              appBar: AppBar(
                //Barra superior com acesso ao historico
                    backgroundColor: Color.fromRGBO(228, 232, 241, 1),
                    shadowColor:  Colors.transparent,

                    title: Text('Historico', style: TextStyle(color: Color.fromRGBO(82, 113, 170, 1)),),
              ),
              body: Column(
                children: <Widget>[
                        Display(memory.value), //Display onde será mostrado os valores calculados
                        Keyboard(_onPressed),//Teclado com os botoes
          ],
        ),
      ),
    );
  }
}