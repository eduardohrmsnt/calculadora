import 'package:flutter/material.dart';
import 'screens/calculator.dart';

import 'package:firebase_core/firebase_core.dart'  as firebase_core;

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //inicializa o firebase
  await firebase_core.Firebase.initializeApp();
  runApp(Calculator());
}

