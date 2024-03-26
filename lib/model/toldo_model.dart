class ToldoModel {
  int? idToldo;
  int? cantidad;
  String? id_venta;
  double? precio;

  ToldoModel({
    this.idToldo,
    this.cantidad,
    this.id_venta,
    this.precio
  });

  factory ToldoModel.fromMap(Map<String,dynamic> silla) {
    return ToldoModel(
      idToldo: silla['idToldo'],
      cantidad: silla['cantidad'],
      id_venta: silla['id_venta'],
      precio: silla['precio']
    );
  }
}
