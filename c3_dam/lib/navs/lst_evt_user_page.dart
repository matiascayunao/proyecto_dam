import 'package:c3_dam/constants.dart';
import 'package:c3_dam/pages/evento_detalle.dart';
import 'package:c3_dam/services/evento_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
                title: Text(evento['titulo'], style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(evento['categoria']),
                trailing: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Color(kPrimary),
                    side: BorderSide(color: Colors.black),
                  ),
                  child: Icon(Icons.align_vertical_bottom, color: Colors.black),
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
