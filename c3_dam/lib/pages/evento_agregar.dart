import 'package:c3_dam/services/evento_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EventoAgregar extends StatefulWidget {
  const EventoAgregar({super.key});

  @override
  State<EventoAgregar> createState() => _EventoAgregarState();
}

class _EventoAgregarState extends State<EventoAgregar> {
  final formKey = GlobalKey<FormState>();
  TextEditingController tituloCtrl = TextEditingController();
  TextEditingController fechaCtrl = TextEditingController();
  TextEditingController horaCtrl = TextEditingController();
  TextEditingController lugarCtrl = TextEditingController();

  String? categoriaSeleccionada;
  DateTime? fechaSeleccionada;
  TimeOfDay? horaSeleccionada;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Agregar Evento")),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(bottom: 5),
                child: TextFormField(
                  controller: tituloCtrl,
                  decoration: InputDecoration(labelText: "Titulo"),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return "Ingrese el titulo";
                    return null;
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(bottom: 5),
                child: TextFormField(
                  controller: fechaCtrl,
                  readOnly: true,
                  decoration: InputDecoration(labelText: "Fecha", border: InputBorder.none, suffixIcon: Icon(Icons.calendar_month)),
                  onTap: () async {
                    DateTime? fecha = await showDatePicker(context: context, initialDate: fechaSeleccionada ?? DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2100));

                    if (fecha == null) return;

                    setState(() {
                      fechaSeleccionada = fecha;
                      fechaCtrl.text =
                          "${fecha.day.toString().padLeft(2, '0')}/"
                          "${fecha.month.toString().padLeft(2, '0')}/"
                          "${fecha.year}";
                    });
                  },
                  validator: (v) {
                    if (fechaSeleccionada == null) return "Seleccione la fecha";
                    return null;
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(bottom: 5),
                child: TextFormField(
                  controller: horaCtrl,
                  readOnly: true,
                  decoration: InputDecoration(labelText: "Hora", border: InputBorder.none, suffixIcon: Icon(Icons.access_time)),
                  onTap: () async {
                    TimeOfDay? hora = await showTimePicker(context: context, initialTime: horaSeleccionada ?? TimeOfDay.now());

                    if (hora == null) return;

                    setState(() {
                      horaSeleccionada = hora;
                      horaCtrl.text =
                          "${hora.hour.toString().padLeft(2, '0')}:"
                          "${hora.minute.toString().padLeft(2, '0')}";
                    });
                  },
                  validator: (v) {
                    if (horaSeleccionada == null) return "Seleccione la hora";
                    return null;
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(bottom: 5),
                child: TextFormField(
                  controller: lugarCtrl,
                  decoration: InputDecoration(labelText: "Lugar"),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return "Ingrese el lugar";
                    return null;
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(bottom: 5),
                child: FutureBuilder(
                  future: EventoService().categorias_combo(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                      return Text("cargando categorias...");
                    }
                    var categorias = snapshot.data!.docs;
                    return DropdownButtonFormField(
                      decoration: InputDecoration(labelText: "Categoria"),
                      items: categorias.map((categoria) {
                        return DropdownMenuItem(child: Text(categoria['nombre']), value: categoria['nombre'].toString());
                      }).toList(),
                      onChanged: (valor) {
                        categoriaSeleccionada = valor;
                      },
                      validator: (v) {
                        if (categoriaSeleccionada == null) return "Seleccione la categoria";
                        return null;
                      },
                    );
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                width: double.infinity,
                child: FilledButton(
                  child: Text("Agregar evento"),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      DateTime fechaHora = DateTime(fechaSeleccionada!.year, fechaSeleccionada!.month, fechaSeleccionada!.day, horaSeleccionada!.hour, horaSeleccionada!.minute);

                      String autor = FirebaseAuth.instance.currentUser?.displayName ?? FirebaseAuth.instance.currentUser?.email ?? "Sin autor";

                      await EventoService().agregarEvento(tituloCtrl.text.trim(), fechaHora, lugarCtrl.text.trim(), categoriaSeleccionada!, autor);
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
