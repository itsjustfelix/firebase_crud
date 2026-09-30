import 'package:flutter/material.dart';

import '../models/contacto.dart';

class ContactoTile extends StatelessWidget {
  final Contacto contacto;
  final VoidCallback onTap;

  const ContactoTile({super.key, required this.contacto, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Text(contacto.iniciales)),
      title: Text(contacto.nombreCompleto),
      subtitle: Text(contacto.telefono),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
