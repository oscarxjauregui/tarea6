import 'package:flutter/material.dart';
import 'package:tarea6/database/renta_database.dart';
import 'package:tarea6/model/renta_model.dart';
import 'package:tarea6/settings/app_value_notifier.dart';

class AgregarRentaScreen extends StatefulWidget {
  const AgregarRentaScreen({super.key});

  @override
  State<AgregarRentaScreen> createState() => _AgregarRentaScreenState();
}

class _AgregarRentaScreenState extends State<AgregarRentaScreen> {

  RentaDatabase? rentaDB;

  @override
  void initState() {
    super.initState();
    rentaDB = new RentaDatabase();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Renta'),
      ),
      body: ValueListenableBuilder(
        valueListenable: AppValueNotifier.banRentas,
        builder: (context, value, _) {
          return FutureBuilder(
            future: rentaDB!.CONSULTAR(),
            builder: (context, AsyncSnapshot<List<RentaModel>>snapshot), {
              if(snapshot.hasError) {
                return Center(child: Text('Algo salio mal'),);
              }
            }
          );
        }
      )
    );
  }
}