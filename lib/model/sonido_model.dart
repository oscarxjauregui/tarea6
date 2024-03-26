class SonidoModel {
  int? idSonido;
  String? descripcion;
  String? id_venta;
  double? precio;

  SonidoModel({
    this.idSonido,
    this.descripcion,
    this.id_venta,
    this.precio
  });

  factory SonidoModel.fromMap(Map<String,dynamic> silla) {
    return SonidoModel(
      idSonido: silla['idSonido'],
      descripcion: silla['descripcion'],
      id_venta: silla['id_venta'],
      precio: silla['precio']
    );
  }
}
