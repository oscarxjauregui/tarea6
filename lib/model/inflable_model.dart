class InflableModel {
  int? idInflable;
  String? descripcion;
  String? id_venta;
  double? precio;

  InflableModel({
    this.idInflable,
    this.descripcion,
    this.id_venta,
    this.precio
  });

  factory InflableModel.fromMap(Map<String,dynamic> silla) {
    return InflableModel(
      idInflable: silla['idInflable'],
      descripcion: silla['descripcion'],
      id_venta: silla['id_venta'],
      precio: silla['precio']
    );
  }
}
