import 'package:c3_dam/constants.dart';
import 'package:c3_dam/services/evento_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:c3_dam/utils/app_utils.dart';

class EventoDetalle extends StatefulWidget {
  const EventoDetalle({super.key, required this.id});
  final String id;

  @override
  State<EventoDetalle> createState() => _EventoDetalleState();
}

class _EventoDetalleState extends State<EventoDetalle> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text("Detalle del evento")),
      body: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [Color(kSecondary), Color(kPrimary)]),
        ),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(color: Color(0xDDFFFFFF), borderRadius: BorderRadius.circular(15)),
          child: FutureBuilder(
            future: EventoService().detalleEvento(widget.id),
            builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
              if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              var evento = snapshot.data!;
              Timestamp ts = evento['fechaHora'];
              DateTime fechaHora = ts.toDate().toLocal();
              String fechaTxt = DateFormat('dd/MM/yyyy').format(fechaHora);
              String horaTxt = DateFormat('HH:mm').format(fechaHora);
              String categoriaNombre = evento['categoria'];

              final user = FirebaseAuth.instance.currentUser;
              String autorActual = user?.displayName ?? user?.email ?? "";
              bool esAutor = autorActual == (evento['autor'] ?? "");

              return FutureBuilder(
                future: EventoService().categoriaPorNombre(categoriaNombre),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  String fotoCat = "";

                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    var catDoc = snapshot.data!.docs.first;
                    fotoCat = catDoc['foto'].toString();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Informacion del evento"),
                      Row(children: [Text("Titulo: "), Text("${evento['titulo']}")]),
                      Row(children: [Text("Fecha: "), Text(fechaTxt)]),
                      Row(children: [Text("Hora: "), Text(horaTxt)]),
                      Row(children: [Text("Lugar: "), Text("${evento['lugar']}")]),
                      Row(children: [Text("Autor: "), Text("${evento['autor']}")]),
                      Row(children: [Text("Categoria: "), Text(categoriaNombre)]),
                      Spacer(),

                      if (fotoCat != "") Container(child: Image.asset("assets/$fotoCat")),

                      Spacer(),

                      esAutor
                          ? Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(bottom: 10),
                              child: FilledButton(
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
                                child: Text("Eliminar"),
                                onPressed: () async {
                                  bool aceptaBorrar = await AppUtils.mostrarConfirmacion(context, "Borrar evento", "¿Desea borrar este evento ${evento['titulo']}?");

                                  if (aceptaBorrar) {
                                    await EventoService().borrarEvento(evento.id);
                                    AppUtils.mostrarSnackbar(_scaffoldKey.currentContext!, 'Evento Borrado');
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            )
                          : Container(),

                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 15),
                        child: OutlinedButton(
                          child: Text("Volver"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
