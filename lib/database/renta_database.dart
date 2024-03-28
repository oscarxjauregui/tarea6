import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:tarea6/model/renta_model.dart';

class RentaDatabase {
  static final NAMEDB = 'RENTADB';
  static final VERSIONDB = 4;

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    return _database = await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    Directory folder = await getApplicationDocumentsDirectory();
    String pathDB = join(folder.path, NAMEDB);
    return openDatabase(
      pathDB,
      version: VERSIONDB,
      onCreate: (db, version) {
        String query = '''CREATE TABLE tblRenta(
          idRenta INTEGER PRIMARY KEY,
          responsable VARCHAR(100),
          lugar VARCHAR(100),
          fecha VARCHAR(100),
          fechaRecordatorio VARCHAR(100),
          estatus VARCHAR(20),
          sillas VARCHAR(3),
          mesas VARCHAR(3),
          inflable VARCHAR(3),
          toldo VARCHAR(3),
          sonido VARCHAR(3)
          )''';
        db.execute(query);
      },
    );
  }

  Future<int> INSERTAR(Map<String, dynamic> data) async {
    var conexion = await database;
    return conexion.insert('tblRenta', data);
  }

  Future<int> ACTUALIZAR(Map<String, dynamic> data) async {
    var conexion = await database;
    return conexion.update(
      'tblRenta',
      data,
      where: 'idRenta = ?',
      whereArgs: [data['idRenta']],
    );
  }

  Future<int> ELIMINAR(int idRenta) async {
    var conexion = await database;
    return conexion.delete(
      'tblRenta',
      where: 'idRenta = ?',
      whereArgs: [idRenta],
    );
  }

  Future<List<RentaModel>> CONSULTAR() async {
    var conexion = await database;
    var rentas = await conexion.query('tblRenta');
    return rentas.map((renta) => RentaModel.fromMap(renta)).toList();
  }
}
