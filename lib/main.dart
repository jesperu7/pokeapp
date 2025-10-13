import 'package:flutter/material.dart';
import 'package:pokeapp/common/get_it.dart';
import 'package:pokeapp/home_page/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetItInitialization().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

