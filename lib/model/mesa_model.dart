class MesaModel {
  int? idMesa;
  int? cantidad;
  String? id_venta;
  double? precio;

  MesaModel({
    this.idMesa,
    this.cantidad,
    this.id_venta,
    this.precio
  });

  factory MesaModel.fromMap(Map<String,dynamic> silla) {
    return MesaModel(
      idMesa: silla['idMesa'],
      cantidad: silla['cantidad'],
      id_venta: silla['id_venta'],
      precio: silla['precio']
    );
  }
}
