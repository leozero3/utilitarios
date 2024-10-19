import 'package:flutter/material.dart';

class AppTheme {
  // Definindo o tema claro
  static final ThemeData darkTheme = ThemeData(
    // primaryColor: Colors.blueAccent,
    brightness: Brightness.dark,

    useMaterial3: true,

    hintColor: Colors.orange,
    // scaffoldBackgroundColor: Colors.white,
    textTheme: TextTheme(
      bodyLarge: TextStyle(fontSize: 18.0, color: Colors.black),
      bodyMedium: TextStyle(fontSize: 16.0, color: Colors.white),
      headlineSmall: TextStyle(
          fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.black),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue, // Cor do texto no botão
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
  );

  // Definindo o tema escuro (opcional)
  // static final ThemeData darkTheme = ThemeData(
  //   brightness: Brightness.dark,
  //   primaryColor: Colors.grey[800],
  //   hintColor: Colors.tealAccent,
  //   textTheme: TextTheme(
  //     bodyLarge: TextStyle(fontSize: 18.0, color: Colors.white),
  //     bodyMedium: TextStyle(fontSize: 16.0, color: Colors.grey[300]),
  //   ),
  // );
}
