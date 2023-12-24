import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'API/weatherProvider.dart';
import 'Screen/home_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => WeatherProvider(),
      child: const MaterialApp(
        title: 'Weather App',
        home: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        // remove the debug banner
        debugShowCheckedModeBanner: false,
        title: 'Weather App',
        home: HomePage(),
      );
  }
}