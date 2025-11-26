import 'package:cloud_firestore/cloud_firestore.dart';

class EventoService {
  Stream<QuerySnapshot> eventos() {
    return FirebaseFirestore.instance.collection('eventos').snapshots();
  }

  Future<QuerySnapshot> categoriasCombo() {
    return FirebaseFirestore.instance.collection('categorias').orderBy('nombre').get();
  }

  Future<void> agregarEvento(String titulo, DateTime fechaHora, String lugar, String categoria, String autor) {
    return FirebaseFirestore.instance.collection('eventos').doc().set({'titulo': titulo, 'fechaHora': Timestamp.fromDate(fechaHora.toLocal()), 'lugar': lugar, 'categoria': categoria, 'autor': autor});
  }

  Future<void> borrarEvento(String id) {
    return FirebaseFirestore.instance.collection('eventos').doc(id).delete();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> detalleEvento(String id) {
    return FirebaseFirestore.instance.collection('eventos').doc(id).get();
  }

  Stream<QuerySnapshot> eventosUsuario(String autor) {
    return FirebaseFirestore.instance.collection('eventos').where('autor', isEqualTo: autor).snapshots();
  }

  Future<QuerySnapshot> categoriaPorNombre(String nombre) {
    return FirebaseFirestore.instance.collection('categorias').where('nombre', isEqualTo: nombre).limit(1).get();
  }
}
