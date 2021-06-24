import 'package:cloud_firestore/cloud_firestore.dart';

class Memory{
  FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  static const operations = const['%','/','x','-','+','='];

  final _buffer = [0.0,0.0];
  int _bufferIndex = 0;
  String _value = '0';
  String _operation;
  bool _wipeValue = false; //Esta variavel serve de controle para limpar a tela quando uma operacao é escolhida e vai digitar um novo valor
  String _lastCommand;

  String get value{
    return _value;
  }

  //Metodo para gravar o resultado no firebase
  Future<void> _addResult(double val1,double val2,double result, String operation) async {
    await _fireStore.collection('history').add({
        'value1':val1,
        'value2':val2,
        'operation': _operation,
        'result': result

    });
  }

  //Metodo para ler o digito que foi pressionado no botao
  void applyCommand(String command){

    //Caso esteja pressionando um botao de operacao seguido de outro
    //mantem sempre a ultima operacao digitada
    if(_isReplacingOperation(command)){
      _operation = command;
      return;
    }

    //Se o botao for para limpar (AC = All clear) ira limpar o display e todas as variaveis.
    if(command == 'AC'){
      _allClear();
    }
    else if( operations.contains(command)){
      //Se nao, se for uma operacao vai setar a operacao atual escolhida
      _setOperation(command);
    }
    else{
      //Se nao for uma operacao e tambem nao for um commando para limpar, entao ele é um número
      _addDigit(command);
    }
    
    _lastCommand = command;
  }

  //Metodo para verificar se esta digitando um operador após o outro
  _isReplacingOperation(String command){
    return operations.contains(_lastCommand)
        && operations.contains(command)
        && command != '='
        && _lastCommand != '=';
  }

  //Metodo para limpar o display e todos os valores digitados
  _allClear(){
    _value = '0';
    _buffer.setAll(0, [0.0, 0.0]);
    _operation = null;
    _bufferIndex = 0;
    _wipeValue = false;
  }

  //Metodo para setar a operacao escolhida
  _setOperation(String newOperation){
    bool isEqualSign = newOperation ==  '=';

    //Se esta digitando o primeiro valor e nao clicou na operacao de igual
    //Muda a posicao do buffer para digitar o segundo valor
    if(_bufferIndex == 0 ){
      if(!isEqualSign){
      _bufferIndex = 1;
      _operation = newOperation;
      _wipeValue = true;
      }
    } else{
    //Se ja digitou o segundo numero e escolheu outra operacao ele faz o calculo e insere no valor atual o resultado
    //da primeira operacao digitada para um novo calculo com o valor da operacao feita.
      _buffer[0] = _calculate();
      _buffer[1] = 0.0;
      _value = _buffer[0].toString();
      _value = _value.endsWith('.0') ? _value.split('.')[0] : _value;


      _operation = isEqualSign ? null : newOperation;
      _bufferIndex = isEqualSign ? 0 : 1;
      
    }

    //Se for simbolo de igual nao deve limpar a tela pois pode-se assim adicionar mais numeros com o resultado obtido
    _wipeValue = !isEqualSign;
  }

  //Metodo para adicionar um numero no buffer para calculo
  _addDigit(String digit){

    final isDot = digit == '.';
    final wipeValue = (_value == '0' && !isDot) || _wipeValue;
    
    if(isDot && _value.contains('.') && !wipeValue)
    {
      //Retorna caso esteja digitando um ponto após o outro
      return;
    }
    //Evita limpar a tela caso esteja digitando um numero abaixo de 0, ex: 0.40
    final emptyValue = isDot ? '0' : '';
    final currentValue = wipeValue ? emptyValue : _value;
    _value = currentValue + digit;
    _wipeValue = false;

    //Transforma o digito em double na posicao atual do buffer para calculo
    _buffer[_bufferIndex] = double.tryParse(_value) ?? 0;
  }

  _calculate(){
    double value = 0;
    //Calcula conforme a operacao definida
    switch(_operation){
      case '%': value = _buffer[0] % _buffer[1]; break;
      case '-': value =  _buffer[0] - _buffer[1];break;
      case '+': value =  _buffer[0] + _buffer[1];break;
      case '/': value =  _buffer[0] / _buffer[1];break;
      case 'x': value =  _buffer[0] * _buffer[1];break;
      default: value =  _buffer[0];
    }
    //Adiciona o resultado no firebase
    _addResult(_buffer[0],_buffer[1], value, _operation);
    
    return value;
  }

}