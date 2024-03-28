import 'package:flutter/material.dart';
import 'package:tarea6/screens/agregar_renta.dart';
import 'package:tarea6/screens/historial_screen.dart';
import 'package:tarea6/screens/home_screen.dart';
import 'package:tarea6/settings/app_value_notifier.dart';
import 'package:tarea6/settings/theme.dart';

void main() async {
  //integracion
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: AppValueNotifier.banTheme,
        builder: (context, value, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: value
                ? ThemeApp.darkTheme(context)
                : ThemeApp.lightTheme(context),
            home: HomeScreen(),
            routes: {
              "/add": (BuildContext context) => const AgregarRentaScreen(),
              "/historial": (BuildContext context) => const HistorialScreen(),
            },
          );
        });
  }

}
