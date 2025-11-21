import 'package:flutter/material.dart';
import 'screens/categories_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Расклады Таро Insolate',
      theme: ThemeData(
        primaryColor: Color(0xFF387FAD),
        colorScheme: ColorScheme.light(
          primary: Color(0xFF387FAD),
          secondary: Color(0xFFAFA376),
          background: Color(0xFFf8f9fa),
        ),
        scaffoldBackgroundColor: Color(0xFFf8f9fa),
      ),
      home: CategoriesScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}