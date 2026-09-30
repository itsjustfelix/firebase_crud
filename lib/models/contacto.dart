import 'package:cloud_firestore/cloud_firestore.dart';

class Contacto {
  final String? id;
  final String nombre;
  final String apellido;
  final String telefono;

  Contacto({
    this.id,
    required this.nombre,
    required this.apellido,
    required this.telefono,
  });

  String get nombreCompleto => '$nombre $apellido';

  String get iniciales {
    final n = nombre.isNotEmpty ? nombre[0] : '';
    final a = apellido.isNotEmpty ? apellido[0] : '';
    return '$n$a'.toUpperCase();
  }

  factory Contacto.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return Contacto(
      id: doc.id,
      nombre: data['nombre'] ?? '',
      apellido: data['apellido'] ?? '',
      telefono: data['telefono'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'nombre': nombre,
    'apellido': apellido,
    'telefono': telefono,
  };
}
