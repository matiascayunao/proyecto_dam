import 'package:c3_dam/constants.dart';
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
      backgroundColor: Color(kPrimary),
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
                  validator: (titulo) {
                    if (titulo!.isEmpty) {
                      return "Ingrese el titulo";
                    }
                    if (titulo.length < 3) {
                      return "El titulo debe tener al menos 3 caracteres";
                    }
                    if (titulo.length > 50) {
                      return "El titulo no debe exceder los 50 caracteres";
                    }
                    if (titulo.trim().contains('  ')) {
                      return "El titulo no puede contener espacios consecutivos";
                    }
                    if (titulo.startsWith(' ') || titulo.endsWith(' ')) {
                      return "El titulo no puede comenzar o terminar con un espacio";
                    }
                    if (titulo.contains(RegExp(r'[!@#\$%\^&\*\(\)_\+\-=\[\]\{\};:"\\|,.<>\/?]'))) {
                      return "El titulo no puede contener caracteres especiales";
                    }
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
                    DateTime? fecha = await showDatePicker(context: context, initialDate: fechaSeleccionada ?? DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2100));

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
                    if (fechaSeleccionada == null) {
                      return "Seleccione la fecha";
                    }
                    if (fechaSeleccionada!.isBefore(DateTime.now())) {
                      return "La fecha no puede ser anterior a la fecha actual";
                    }
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
                    if (horaSeleccionada == null) {
                      return "Seleccione la hora";
                    }
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
                  validator: (lugar) {
                    if (lugar!.isEmpty) {
                      return 'Indique el lugar';
                    }
                    if (lugar.length < 3) {
                      return 'El lugar debe tener al menos 3 caracteres';
                    }
                    if (lugar.length > 100) {
                      return 'El lugar no debe exceder los 100 caracteres';
                    }
                    if (lugar.startsWith(' ') || lugar.endsWith(' ')) {
                      return "El lugar no puede comenzar o terminar con un espacio";
                    }
                    return null;
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(bottom: 5),
                child: FutureBuilder(
                  future: EventoService().categoriasCombo(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                      return Text("cargando categorias...");
                    }
                    var categorias = snapshot.data!.docs;
                    return DropdownButtonFormField(
                      decoration: InputDecoration(labelText: "Categoria"),
                      validator: (categoria) {
                        if (categoria == null) {
                          return 'Seleccione una categoria';
                        }
                        return null;
                      },

                      items: categorias.map((categoria) {
                        return DropdownMenuItem(child: Text(categoria['nombre']), value: categoria['nombre'].toString());
                      }).toList(),
                      onChanged: (valor) {
                        categoriaSeleccionada = valor;
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

                      String autor = FirebaseAuth.instance.currentUser?.displayName ?? "Sin autor";

                      await EventoService().agregarEvento(tituloCtrl.text.trim(), fechaHora, lugarCtrl.text.trim(), categoriaSeleccionada!, autor);

                      setState(() {
                        tituloCtrl.clear();
                        fechaCtrl.clear();
                        horaCtrl.clear();
                        lugarCtrl.clear();

                        categoriaSeleccionada = null;
                        fechaSeleccionada = null;
                        horaSeleccionada = null;
                      });
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
