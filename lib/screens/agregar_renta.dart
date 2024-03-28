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
  
  String? _selectedEstatus;
  final List<String> _estatusOptions = [
    'Finalizado',
    'Pendiente',
    'Cancelado',
  ];

  final TextEditingController _responsableController = TextEditingController();
  final TextEditingController _lugarController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();
  final TextEditingController _fechaRecordatorioController =
      TextEditingController();
  final TextEditingController _estatusController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _responsableController,
              decoration: InputDecoration(labelText: 'Responsable'),
            ),
            TextField(
              controller: _lugarController,
              decoration: InputDecoration(labelText: 'Lugar'),
            ),
            TextField(
              controller: _fechaController,
              decoration: InputDecoration(labelText: 'Fecha'),
            ),
            DropdownButtonFormField<String>(
              value: _selectedEstatus,
              onChanged: (newValue) {
                setState(() {
                  _selectedEstatus = newValue;
                });
              },
              items: _estatusOptions.map((estatus) {
                return DropdownMenuItem<String>(
                  value: estatus,
                  child: Text(estatus),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Estatus',
                border: OutlineInputBorder(),
              ),
            ),
            TextField(
              controller: _precioController,
              decoration: InputDecoration(labelText: 'Total'),
            ),
            SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () async {
                _agregarRenta();
              },
              child: Text('Agregar'),
            ),
          ],
        ),
      ),
    );
  }

  void _agregarRenta() async {
    final nuevaRenta = RentaModel(
      responsable: _responsableController.text,
      lugar: _lugarController.text,
      fecha: _fechaController.text,
      fecharecordatorio: _fechaController.text,
      estatus: _estatusController.text,
      precio: double.parse(_precioController.text),
    );

    await rentaDB!.INSERTAR(nuevaRenta.toMap());
    Navigator.pop(context, true); // Regresar a la pantalla anterior
  }
}
