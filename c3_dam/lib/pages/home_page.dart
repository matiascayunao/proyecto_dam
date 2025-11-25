import 'package:c3_dam/constants.dart';
import 'package:c3_dam/pages/evento_agregar.dart';
import 'package:c3_dam/navs/lst_evt_page.dart';
import 'package:c3_dam/navs/lst_evt_user_page.dart';
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

  List<Widget> _paginas = [LstEvtPage(), EventoAgregar(), LstEvtUserPage()];

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final authService = AuthService();

    return Scaffold(
      appBar: AppBar(title: Text("Listado de Eventos")),

      endDrawer: NavigationDrawer(
        backgroundColor: Color(kPrimary),
        indicatorColor: Colors.white,
        children: [
          DrawerHeader(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(bottom: 8),
                  child: Icon(Icons.account_circle, size: 85, color: Colors.white),
                ),

                Text(user?.displayName ?? user?.email ?? "Sin nombre", style: TextStyle(fontSize: 16)),
              ],
            ),
          ),

          Container(
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.symmetric(horizontal: 12),
            width: double.infinity,
            child: FilledButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
              child: Text("Cerrar sesión"),
              onPressed: () async {
                await authService.signOut();
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),

      body: Padding(
        padding: EdgeInsets.all(5),
        child: IndexedStack(children: _paginas, index: _paginaSeleccionada),
      ),

      bottomNavigationBar: NavigationBar(
        backgroundColor: Color(kSecondary),
        destinations: [
          NavigationDestination(
            icon: Icon(MdiIcons.calendarOutline, color: Colors.white),
            selectedIcon: Icon(MdiIcons.calendar, size: 30, color: Color(kPrimary)),
            label: "Eventos Globales",
          ),
          NavigationDestination(
            icon: Icon(MdiIcons.plusCircleOutline, color: Colors.white),
            selectedIcon: Icon(MdiIcons.plusCircle, size: 30, color: Color(kPrimary)),
            label: "Agregar Evento",
          ),
          NavigationDestination(
            icon: Icon(MdiIcons.calendarAccountOutline, color: Colors.white),
            selectedIcon: Icon(MdiIcons.calendarAccount, size: 30, color: Color(kPrimary)),
            label: "Eventos Propios",
          ),
        ],
        selectedIndex: _paginaSeleccionada,
        onDestinationSelected: (indicePagina) {
          setState(() {
            _paginaSeleccionada = indicePagina;
          });
        },
      ),
    );
  }
}
