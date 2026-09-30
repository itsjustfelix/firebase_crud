import 'package:flutter/material.dart';

import '../models/contacto.dart';
import '../services/contacto_service.dart';
import '../widgets/contacto_tile.dart';
import 'detalle_screen.dart';
import 'formulario_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = ContactoService();

    return Scaffold(
      appBar: AppBar(title: const Text('Contactos')),
      body: StreamBuilder<List<Contacto>>(
        stream: service.listar(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final contactos = snapshot.data ?? [];
          if (contactos.isEmpty) {
            return const Center(child: Text('No hay contactos. ¡Agrega uno!'));
          }
          return ListView.separated(
            itemCount: contactos.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final c = contactos[i];
              return ContactoTile(
                contacto: c,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetalleScreen(contactoId: c.id!),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.person_add),
        label: const Text('Agregar'),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FormularioScreen()),
        ),
      ),
    );
  }
}
