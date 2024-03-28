class RentaModel {
  int? idRenta;
  String? responsable;
  String? lugar;
  String? fecha;
  String? fecharecordatorio;
  String? estatus;
  String? sillas;
  String? mesas;
  String? inflable;
  String? toldo;
  String? sonido;

  RentaModel({
    this.idRenta,
    required this.responsable,
    required this.lugar,
    required this.fecha,
    required this.fecharecordatorio,
    required this.estatus,
    required this.sillas,
    required this.mesas,
    required this.inflable,
    required this.toldo,
    required this.sonido,
  });

  factory RentaModel.fromMap(Map<String, dynamic> map) {
    return RentaModel(
      idRenta: map['idRenta'],
      responsable: map['responsable'],
      lugar: map['lugar'],
      fecha: map['fecha'],
      fecharecordatorio: map['fecharecordatorio'],
      estatus: map['estatus'],
      sillas: map['sillas'],
      mesas: map['mesas'],
      inflable: map['inflable'],
      toldo: map['toldo'],
      sonido: map['sonido'],
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
      'sillas': sillas,
      'mesas': mesas,
      'inflable': inflable,
      'toldo': toldo,
      'sonido': sonido,
    };
  }
}
