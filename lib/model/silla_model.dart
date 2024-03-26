class SillaModel {
  int? idSilla;
  int? cantidad;
  String? id_venta;
  double? precio;

  SillaModel({
    this.idSilla,
    this.cantidad,
    this.id_venta,
    this.precio
  });

  factory SillaModel.fromMap(Map<String,dynamic> silla) {
    return SillaModel(
      idSilla: silla['idSilla'],
      cantidad: silla['cantidad'],
      id_venta: silla['id_venta'],
      precio: silla['precio']
    );
  }
}
