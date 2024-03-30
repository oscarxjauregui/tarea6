import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tarea6/database/renta_database.dart';
import 'package:tarea6/model/renta_model.dart';
import 'package:badges/badges.dart' as badges;

class AcualizarRentaScreen extends StatefulWidget {
  final RentaModel renta;
  const AcualizarRentaScreen({Key? key, required this.renta}) : super(key: key);

  @override
  State<AcualizarRentaScreen> createState() => _AcualizarRentaScreenState();
}

class _AcualizarRentaScreenState extends State<AcualizarRentaScreen> {
  RentaDatabase? rentaDB;
  final _formKey = GlobalKey<FormState>();

  String? _selectedEstatus;
  final List<String> _estatusOptions = [
    'Finalizado',
    'Pendiente',
    'Cancelado',
  ];

  final TextEditingController _responsableController = TextEditingController();
  final TextEditingController _lugarController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();
  final TextEditingController _fechaRecordatorioController =
      TextEditingController();
  final TextEditingController _estatusController = TextEditingController();
  final TextEditingController _sillasController =
      TextEditingController(text: '0');
  final TextEditingController _mesasController =
      TextEditingController(text: '0');
  final TextEditingController _inflableController =
      TextEditingController(text: '0');
  final TextEditingController _toldoController =
      TextEditingController(text: '0');
  final TextEditingController _sonidoController =
      TextEditingController(text: '0');
  final TextEditingController _totalController =
      TextEditingController(text: '0');

  @override
  void initState() {
    super.initState();
    rentaDB = new RentaDatabase();
    _setInitialValues();
    _updateTotal();
  }

  void _setInitialValues() {
    _responsableController.text = widget.renta.responsable ?? '';
    _lugarController.text = widget.renta.lugar ?? '';
    _fechaController.text = widget.renta.fecha ?? '';
    _fechaRecordatorioController.text = widget.renta.fecharecordatorio ?? '';
    _estatusController.text = widget.renta.estatus ?? '';
    _sillasController.text = widget.renta.sillas ?? '';
    _mesasController.text = widget.renta.mesas ?? '';
    _inflableController.text = widget.renta.inflable ?? '';
    _toldoController.text = widget.renta.toldo ?? '';
    _sonidoController.text = widget.renta.sonido ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Actualizar Renta'),
        actions: [
          badges.Badge(
            badgeContent: Text(
              _totalController.text,
              style: TextStyle(color: Colors.white),
            ),
            child: Icon(Icons.table_rows),
            badgeAnimation: badges.BadgeAnimation.scale(),
            //position: badges.BadgePosition.topStart(),
          ),
          Text('    ')
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                    controller: _responsableController,
                    decoration: InputDecoration(labelText: 'Responsable'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa el responsable';
                      }
                      return null;
                    }),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                    controller: _lugarController,
                    decoration: InputDecoration(labelText: 'Lugar'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa el lugar';
                      }
                      return null;
                    }),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                    controller: _fechaController,
                    keyboardType: TextInputType.none,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Fecha',
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(), //get today's date
                        firstDate: DateTime(
                            2000), //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2101),
                      );

                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        DateTime recordatorioDate =
                            pickedDate.subtract(Duration(days: 2));
                        String formattedRecordatorioDate =
                            DateFormat('yyyy-MM-dd').format(recordatorioDate);
                        setState(() {
                          _fechaController.text = formattedDate;
                          _fechaRecordatorioController.text =
                              formattedRecordatorioDate;
                        });
                      } else {
                        print("Date is not selected");
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa la fecha';
                      }
                      return null;
                    }),
                SizedBox(
                  height: 16,
                ),
                DropdownButtonFormField<String>(
                  value: _selectedEstatus,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedEstatus = newValue;
                      _estatusController.text = newValue ?? '';
                    });
                  },
                  items: _estatusOptions.map((estatus) {
                    return DropdownMenuItem<String>(
                      value: estatus,
                      child: Text(estatus),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Estatus',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa el El estatus';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          int sillas =
                              int.tryParse(_sillasController.text) ?? 0;
                          sillas++;
                          _sillasController.text = sillas.toString();
                          _updateTotal();
                        });
                      },
                      icon: Icon(Icons.add),
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            int sillas =
                                int.tryParse(_sillasController.text) ?? 0;
                            if (sillas > 0) {
                              sillas--;
                              _sillasController.text = sillas.toString();
                              _updateTotal();
                            }
                          });
                        },
                        icon: Icon(Icons.remove)),
                    Text('${_sillasController.text} Juegos de 10 sillas'),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          int mesas = int.tryParse(_mesasController.text) ?? 0;
                          mesas++;
                          _mesasController.text = mesas.toString();
                          _updateTotal();
                        });
                      },
                      icon: Icon(Icons.add),
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            int mesas =
                                int.tryParse(_mesasController.text) ?? 0;
                            if (mesas > 0) {
                              mesas--;
                              _mesasController.text = mesas.toString();
                              _updateTotal();
                            }
                          });
                        },
                        icon: Icon(Icons.remove)),
                    Text('${_mesasController.text} Mesas'),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          int inflable =
                              int.tryParse(_inflableController.text) ?? 0;
                          if (inflable < 10) {
                            inflable++;
                            _inflableController.text = inflable.toString();
                            _updateTotal();
                          }
                        });
                      },
                      icon: Icon(Icons.add),
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            int inflable =
                                int.tryParse(_inflableController.text) ?? 0;
                            if (inflable > 0) {
                              inflable--;
                              _inflableController.text = inflable.toString();
                              _updateTotal();
                            }
                          });
                        },
                        icon: Icon(Icons.remove)),
                    Text('${_inflableController.text} Inflables'),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          int toldo = int.tryParse(_toldoController.text) ?? 0;
                          if (toldo < 20) {
                            toldo++;
                            _toldoController.text = toldo.toString();
                            _updateTotal();
                          }
                        });
                      },
                      icon: Icon(Icons.add),
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            int toldo =
                                int.tryParse(_toldoController.text) ?? 0;
                            if (toldo > 0) {
                              toldo--;
                              _toldoController.text = toldo.toString();
                              _updateTotal();
                            }
                          });
                        },
                        icon: Icon(Icons.remove)),
                    Text('${_toldoController.text} Toldos'),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          int sonido =
                              int.tryParse(_sonidoController.text) ?? 0;
                          if (sonido < 2) {
                            sonido++;
                            _sonidoController.text = sonido.toString();
                            _updateTotal();
                          }
                        });
                      },
                      icon: Icon(Icons.add),
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            int sonido =
                                int.tryParse(_sonidoController.text) ?? 0;
                            if (sonido > 0) {
                              sonido--;
                              _sonidoController.text = sonido.toString();
                              _updateTotal();
                            }
                          });
                        },
                        icon: Icon(Icons.remove)),
                    Text('${_sonidoController.text} Sonido'),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      //_agregarRenta();
                      _actualizarRenta();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Renta de ${_responsableController.text} actualizada'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  child: Text('Actualizar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _updateTotal() {
    int total = 0;
    total += int.tryParse(_sillasController.text) ?? 0;
    total += int.tryParse(_mesasController.text) ?? 0;
    total += int.tryParse(_inflableController.text) ?? 0;
    total += int.tryParse(_toldoController.text) ?? 0;
    total += int.tryParse(_sonidoController.text) ?? 0;
    _totalController.text = total.toString();
  }

  void _actualizarRenta() async {
    final rentaActualizada = RentaModel(
      idRenta: widget.renta.idRenta,
      responsable: _responsableController.text,
      lugar: _lugarController.text,
      fecha: _fechaController.text,
      fecharecordatorio: _fechaRecordatorioController.text,
      estatus: _estatusController.text,
      sillas: _sillasController.text,
      mesas: _mesasController.text,
      inflable: _inflableController.text,
      toldo: _toldoController.text,
      sonido: _sonidoController.text,
    );
    await rentaDB!.ACTUALIZAR(rentaActualizada.toMap());
    Navigator.pushNamed(context, '/pendiente');
  }
}
