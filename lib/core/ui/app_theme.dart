import 'package:flutter/material.dart';

class AppTheme {
  // Definindo o tema escuro
  static final ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      hintColor: Colors.orange,
      textTheme: TextTheme(
        bodyLarge: TextStyle(fontSize: 18.0, color: Colors.black),
        bodyMedium: TextStyle(fontSize: 16.0, color: Colors.white),
        headlineSmall: TextStyle(
            fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor:
              const Color.fromARGB(255, 52, 155, 240), // Cor do texto no botão
          textStyle: TextStyle(fontSize: 18.0),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTickMarkColor: Colors.blue,
        activeTrackColor: Colors.blue,
        inactiveTrackColor: Colors.blue[100],
        valueIndicatorColor: Colors.blue[100],
        thumbColor: Colors.orange,
        overlayColor: Colors.orange.withOpacity(0.3),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
        labelStyle: TextStyle(color: Colors.blue),
        hintStyle: TextStyle(color: Colors.white),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: Colors.grey[900], // Cor de fundo do AlertDialog
        titleTextStyle: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.white, // Cor do título do AlertDialog
        ),
        contentTextStyle: TextStyle(
          fontSize: 16.0,
          color: Colors.white, // Cor do conteúdo do AlertDialog
        ),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(15.0)), // Bordas arredondadas
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          // backgroundColor: Colors.blue, // Cor do texto no TextButton
          textStyle: TextStyle(fontSize: 15.0),
        ),
      ));
}
