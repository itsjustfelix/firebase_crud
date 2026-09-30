import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/contacto.dart';

class ContactoService {
  final _col = FirebaseFirestore.instance.collection('contactos');

  // READ: lista en tiempo real
  Stream<List<Contacto>> listar() {
    return _col
        .orderBy('nombre')
        .snapshots()
        .map(
          (snap) => snap.docs.map((d) => Contacto.fromFirestore(d)).toList(),
        );
  }

  // READ: un solo contacto en tiempo real
  Stream<Contacto?> obtener(String id) {
    return _col
        .doc(id)
        .snapshots()
        .map((d) => d.exists ? Contacto.fromFirestore(d) : null);
  }

  // CREATE
  Future<void> crear(Contacto c) => _col.add(c.toMap());

  // UPDATE
  Future<void> actualizar(Contacto c) => _col.doc(c.id).update(c.toMap());

  // DELETE
  Future<void> eliminar(String id) => _col.doc(id).delete();
}
