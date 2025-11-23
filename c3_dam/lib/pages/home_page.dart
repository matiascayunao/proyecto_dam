import 'package:c3_dam/pages/evento_agregar.dart';
import 'package:c3_dam/tabs/lst_evt_page.dart';
import 'package:c3_dam/tabs/lst_evt_user_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../services/auth_service.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _paginaSeleccionada = 0;

  List<Widget> _paginas = [LstEvtPage(), LstEvtUserPage()];

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: Text("Listado de Eventos"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await authService.signOut();
            },
          ),
        ],
      ),

      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            width: double.infinity,
            color: Colors.blue.shade100,
            child: Text(user?.displayName ?? user?.email ?? "Sin nombre", style: TextStyle(fontSize: 16)),
          ),

          Expanded(
            child: IndexedStack(index: _paginaSeleccionada, children: _paginas),
          ),
        ],
      ),

      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(icon: Icon(MdiIcons.calendar), label: "Eventos Globales"),
          NavigationDestination(icon: Icon(MdiIcons.calendar), label: "Eventos Propios"),
        ],
        selectedIndex: _paginaSeleccionada,
        onDestinationSelected: (indicePagina) {
          setState(() {
            _paginaSeleccionada = indicePagina;
          });
        },
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => EventoAgregar()));
        },
      ),
    );
  }
}
