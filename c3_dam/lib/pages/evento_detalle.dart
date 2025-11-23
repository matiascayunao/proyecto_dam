import 'package:c3_dam/services/evento_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventoDetalle extends StatelessWidget {
  const EventoDetalle({super.key, required this.id});
  final String id;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detalle del evento")),
      body: Padding(
        padding: EdgeInsets.all(5),
        child: FutureBuilder(
          future: EventoService().detalleEvento(id),
          builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            var evento = snapshot.data!;
            Timestamp ts = evento['fechaHora'];
            DateTime fechaHora = ts.toDate().toLocal();
            String fechaTxt = DateFormat('dd/MM/yyyy').format(fechaHora);
            String horaTxt = DateFormat('HH:mm').format(fechaHora);
            String categoriaNombre = evento['categoria'];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Informacion del evento"),
                SizedBox(height: 10),

                Row(
                  children: [
                    Text("Titulo: "),
                    Expanded(child: Text("${evento['titulo']}")),
                  ],
                ),
                SizedBox(height: 5),

                Row(children: [Text("Fecha: "), Text(fechaTxt)]),
                SizedBox(height: 5),

                Row(children: [Text("Hora: "), Text(horaTxt)]),
                SizedBox(height: 5),

                Row(
                  children: [
                    Text("Lugar: "),
                    Expanded(child: Text("${evento['lugar']}")),
                  ],
                ),
                SizedBox(height: 5),

                Row(
                  children: [
                    Text("Autor: "),
                    Expanded(child: Text("${evento['autor']}")),
                  ],
                ),
                SizedBox(height: 5),

                Row(
                  children: [
                    Text("Categoria: "),
                    Expanded(child: Text(categoriaNombre)),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
