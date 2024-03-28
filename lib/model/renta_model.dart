class RentaModel {
  int? idRenta;
  String responsable;
  String lugar;
  String fecha;
  String fecharecordatorio;
  String estatus;
  double precio;

  RentaModel({
    this.idRenta,
    required this.responsable,
    required this.lugar,
    required this.fecha,
    required this.fecharecordatorio,
    required this.estatus,
    required this.precio,
  });

  factory RentaModel.fromMap(Map<String, dynamic> map) {
    return RentaModel(
      idRenta: map['idRenta'],
      responsable: map['responsable'],
      lugar: map['lugar'],
      fecha: map['fecha'],
      fecharecordatorio: map['fecharecordatorio'],
      estatus: map['estatus'],
      precio: map['precio'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idRenta': idRenta,
      'responsable': responsable,
      'lugar': lugar,
      'fecha': fecha,
      'fecharecordatorio': fecharecordatorio,
      'estatus': estatus,
      'precio': precio,
    };
  }
}
