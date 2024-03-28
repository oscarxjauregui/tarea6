import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tarea6/database/renta_database.dart';
import 'package:tarea6/model/renta_model.dart';
import 'package:tarea6/settings/app_value_notifier.dart';

class HistorialScreen extends StatefulWidget {
  const HistorialScreen({super.key});

  @override
  State<HistorialScreen> createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
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
        title: Text('Historial'),
      ),
      body: ValueListenableBuilder(
          valueListenable: AppValueNotifier.banRentas,
          builder: (context, value, _) {
            return FutureBuilder(
              future: rentaDB!.CONSULTAR(),
              builder: (context, AsyncSnapshot<List<RentaModel>> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Algo salio mal'),
                  );
                } else {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return itemRenta(snapshot.data![index]);
                        },
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }
              },
            );
          }),
    );
  }

  Widget itemRenta(RentaModel renta) {
    Color statusColor = Colors.greenAccent;
    if (renta.estatus == 'Pendiente') {
      statusColor = Colors.orange;
    } else {
      if (renta.estatus == 'Cancelado') {
        statusColor = Colors.red;
      }
    }

    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          color: statusColor,
          //color: Colors.greenAccent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black, width: 2)),
      padding: EdgeInsets.all(10),
      height: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${renta.responsable}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              IconButton(
                onPressed: () async {
                  ArtDialogResponse response = await ArtSweetAlert.show(
                    barrierDismissible: false,
                    context: context,
                    artDialogArgs: ArtDialogArgs(
                      denyButtonText: "Cancelar",
                      title: "Quires borrarlo?",
                      text: "No podras revertir la accion",
                      confirmButtonText: "Si, borralo",
                      type: ArtSweetAlertType.warning,
                    ),
                  );
                  if (response == null) {
                    return;
                  }
                  if (response.isTapConfirmButton) {
                    rentaDB!.ELIMINAR(renta.idRenta!).then((value) {
                      if (value > 0) {
                        ArtSweetAlert.show(
                          context: context,
                          artDialogArgs: ArtDialogArgs(
                              type: ArtSweetAlertType.success,
                              text: "Eliminado"),
                        );
                        AppValueNotifier.banRentas.value =
                            !AppValueNotifier.banRentas.value;
                      }
                    });
                    return;
                  }
                },
                icon: Icon(Icons.delete),
              ),
            ],
          ),
          Text('Lugar: ${renta.lugar}'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Estatus: ${renta.estatus}'),
              Text('Fecha: ${renta.fecha}'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Sillas: ${renta.sillas}'),
              Text('Mesas: ${renta.mesas}'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Inflable: ${renta.inflable}'),
              Text('Toldo: ${renta.toldo}'),
            ],
          ),
          Text('Sonido: ${renta.sonido}'),
        ],
      ),
    );
  }
}
