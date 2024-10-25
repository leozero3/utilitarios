import 'package:flutter/material.dart';

class AppTheme {
  // Definindo o tema escuro
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    hintColor: Colors.orange,
    textTheme: TextTheme(
      bodyLarge: TextStyle(fontSize: 18.0, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 16.0, color: Colors.white),
      headlineSmall: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
        color: Colors.orange,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor:
            Color.fromARGB(255, 52, 155, 240), // Cor do texto no botão
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
      filled: true,
      fillColor: Colors.grey[850], // Fundo do TextField
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: Colors.white, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(
            color: const Color.fromARGB(255, 99, 96, 139), width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: Colors.blue, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: Colors.red, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
      ),
      labelStyle: TextStyle(color: const Color.fromARGB(255, 182, 183, 184)),
      hintStyle: TextStyle(color: Colors.white),
      contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      errorStyle: TextStyle(color: Colors.redAccent),
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
        textStyle: TextStyle(fontSize: 15.0),
      ),
    ),
  );
}
