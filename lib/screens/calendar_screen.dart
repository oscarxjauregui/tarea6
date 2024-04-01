import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tarea6/database/renta_database.dart';
import 'package:tarea6/model/renta_model.dart';
import 'package:tarea6/screens/actualizar_renta.dart';
import 'package:tarea6/settings/app_value_notifier.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late final ValueNotifier<List<RentaModel>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  RentaDatabase? rentaDB;

  Map<DateTime, List<RentaModel>> _eventsByDate = {};

  @override
  void initState() {
    super.initState();
    rentaDB = new RentaDatabase();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier<List<RentaModel>>([]);
    _loadEventsForDays(_focusedDay.subtract(const Duration(days: 15)),
        _focusedDay.add(const Duration(days: 15)));
  }

  Future<void> _loadEventsForDays(DateTime start, DateTime end) async {
    for (var day = start;
        day.isBefore(end) || day.isAtSameMomentAs(end);
        day = day.add(const Duration(days: 1))) {
      await _loadEventsForDay(day);
    }
  }

  Future<void> _loadEventsForDay(DateTime day) async {
    String formattedDate =
        "${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}";
    List<RentaModel> rentas =
        await RentaDatabase().getRentasExpiracion(formattedDate);
    _eventsByDate[day] = rentas;
    if (isSameDay(day, _selectedDay)) {
      _selectedEvents.value = rentas;
    }
  }

  List<RentaModel> _getEventsForRange(DateTime start, DateTime end) {
    final events = <RentaModel>[];

    for (var day = start;
        day.isBefore(end) || day.isAtSameMomentAs(end);
        day = day.add(const Duration(days: 1))) {
      if (_eventsByDate.containsKey(day)) {
        events.addAll(_eventsByDate[day]!);
      }
    }
    return events;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null;
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });
      _selectedEvents.value = _eventsByDate[selectedDay] ?? [];
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _eventsByDate[start] ?? [];
    } else if (end != null) {
      _selectedEvents.value = _eventsByDate[end] ?? [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pendientes'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/pendiente');
            },
            icon: Icon(Icons.list),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/add');
            },
            icon: Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/historial');
            },
            icon: Icon(Icons.history),
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar<RentaModel>(
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: const CalendarStyle(
              selectedTextStyle: TextStyle(color: Colors.white),
              selectedDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              outsideDaysVisible: false,
            ),
            onDaySelected: _onDaySelected,
            onRangeSelected: _onRangeSelected,
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
              _loadEventsForDays(focusedDay.subtract(const Duration(days: 15)),
                  focusedDay.add(const Duration(days: 15)));
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            eventLoader: (day) => _eventsByDate[day] ?? [],
          ),
          const SizedBox(height: 10.0),
          Expanded(
              child: ValueListenableBuilder<List<RentaModel>>(
            valueListenable: _selectedEvents,
            builder: (context, value, _) {
              return ListView.builder(
                itemCount: value.length,
                itemBuilder: ((context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      onTap: () => print('${value[index].responsable}'),
                      title: Text(
                        '${value[index].responsable}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('${value[index].lugar}\n'
                          '${value[index].fecha}\n'
                          'Estatus: ${value[index].estatus}\n'
                          'Sillas: ${value[index].sillas}               '
                          'Mesas: ${value[index].mesas}\n'
                          'Inflable: ${value[index].inflable}            '
                          'Toldos: ${value[index].toldo}\n'
                          'Sonido: ${value[index].sonido}',
                          style: TextStyle(fontSize: 15),
                          ),
                      tileColor: value[index].estatus == 'Pendiente'
                          ? Colors.orange
                          : value[index].estatus == 'Cancelado'
                              ? Colors.red 
                              : Colors.greenAccent, 
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AcualizarRentaScreen(
                                        renta: value[index],
                                      ),
                                    ),
                                  );
                                },
                                icon: Icon(Icons.edit),
                              ),
                              IconButton(
                                onPressed: () async {
                                  ArtDialogResponse response =
                                      await ArtSweetAlert.show(
                                    barrierDismissible: false,
                                    context: context,
                                    artDialogArgs: ArtDialogArgs(
                                      denyButtonText: "Cancelar",
                                      title: "¿Quieres borrarlo?",
                                      text: "No podrás revertir la acción",
                                      confirmButtonText: "Sí, bórralo",
                                      type: ArtSweetAlertType.warning,
                                    ),
                                  );
                                  if (response == null) {
                                    return;
                                  }
                                  if (response.isTapConfirmButton) {
                                    rentaDB!
                                        .ELIMINAR(value[index].idRenta!)
                                        .then((value) {
                                      if (value > 0) {
                                        ArtSweetAlert.show(
                                          context: context,
                                          artDialogArgs: ArtDialogArgs(
                                            type: ArtSweetAlertType.success,
                                            text: "Eliminado",
                                          ),
                                        );
                                        AppValueNotifier.banRentas.value =
                                            !AppValueNotifier.banRentas.value;
                                      }
                                    });
                                    return;
                                  }
                                },
                                icon: Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              );
            },
          ))
        ],
      ),
    );
  }
}
