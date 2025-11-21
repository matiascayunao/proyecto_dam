import 'package:cloud_firestore/cloud_firestore.dart';

class EventoService {
  Stream<QuerySnapshot> categorias() {
    return FirebaseFirestore.instance.collection('categorias').snapshots();
  }

  Stream<QuerySnapshot> eventos() {
    return FirebaseFirestore.instance.collection('eventos').snapshots();
  }
}
