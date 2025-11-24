import 'package:c3_dam/pages/evento_detalle.dart';
import 'package:c3_dam/services/evento_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LstEvtUserPage extends StatefulWidget {
  LstEvtUserPage({super.key});

  @override
  State<LstEvtUserPage> createState() => _LstEvtUserPageState();
}

class _LstEvtUserPageState extends State<LstEvtUserPage> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    String autorActual = user?.displayName ?? user?.email ?? "";

    return Padding(
      padding: EdgeInsets.all(10),
      child: StreamBuilder(
        stream: EventoService().eventosUsuario(autorActual),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.separated(
            separatorBuilder: (context, index) => Divider(),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var evento = snapshot.data!.docs[index];
              return ListTile(
                leading: Icon(MdiIcons.calendar),
                title: Text(evento['titulo']),
                subtitle: Text(evento['categoria']),
                trailing: OutlinedButton(
                  child: Icon(Icons.align_vertical_bottom),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => EventoDetalle(id: evento.id)));
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
