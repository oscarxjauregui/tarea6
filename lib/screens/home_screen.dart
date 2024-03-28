import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(),
              child: Text(
                'Inicio',
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Agregar'),
              subtitle: Text('Agregar nueva renta'),
              trailing: Icon(Icons.chevron_right),
               onTap: () => Navigator.pushNamed(context, '/add'),
            ),
            ListTile(
              leading: Icon(Icons.pending),
              title: Text('Pendientes'),
              subtitle: Text('Rentas pendientes'),
              trailing: Icon(Icons.chevron_right),
               onTap: () => Navigator.pushNamed(context, '/add'),
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Historial'),
              subtitle: Text('Historial de todas las rentas'),
              trailing: Icon(Icons.chevron_right),
               onTap: () => Navigator.pushNamed(context, '/historial'),
            ),
          ],
        ),
      ),
      body: Container(),
    );
  }
}
