import 'package:c3_dam/pages/evento_detalle.dart';
import 'package:c3_dam/services/evento_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LstEvtPage extends StatefulWidget {
  LstEvtPage({super.key});

  @override
  State<LstEvtPage> createState() => _LstEvtPageState();
}

class _LstEvtPageState extends State<LstEvtPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: StreamBuilder(
        stream: EventoService().eventos(),
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
