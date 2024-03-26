class RentaModel {
  int? idRenta;
  String? responsable;
  String? lugar;
  String? fecha;
  String? fechaRecordatorio;
  String? estatus;
  double? precio;

  RentaModel({
    this.idRenta,
    this.responsable,
    this.lugar,
    this.fecha,
    this.fechaRecordatorio,
    this.estatus,
    this.precio
  });

  factory RentaModel.fromMap(Map<String,dynamic> renta){
    return RentaModel(
      idRenta: renta['idRenta'],
      responsable: renta['responsable'],
      lugar: renta['lugar'],
      fecha: renta['fecha'],
      fechaRecordatorio: renta['fechaRecordatorio'],
      estatus: renta['estatus'],
      precio: renta['precio']
    );
  }
}