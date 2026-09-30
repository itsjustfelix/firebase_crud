import 'package:flutter/material.dart';

import '../models/contacto.dart';
import '../services/contacto_service.dart';
import 'formulario_screen.dart';

class DetalleScreen extends StatelessWidget {
  final String contactoId;

  const DetalleScreen({super.key, required this.contactoId});

  Future<void> _eliminar(BuildContext context, Contacto c) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar contacto'),
        content: Text('¿Eliminar a ${c.nombreCompleto}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmar != true) return;

    await ContactoService().eliminar(c.id!);
    if (context.mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final service = ContactoService();

    return StreamBuilder<Contacto?>(
      stream: service.obtener(contactoId),
      builder: (context, snapshot) {
        final c = snapshot.data;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Detalle'),
            actions: [
              if (c != null)
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Eliminar',
                  onPressed: () => _eliminar(context, c),
                ),
            ],
          ),
          body: c == null
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 48,
                        child: Text(
                          c.iniciales,
                          style: const TextStyle(fontSize: 32),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Card(
                        child: Column(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.person),
                              title: const Text('Nombre'),
                              subtitle: Text(c.nombre),
                            ),
                            ListTile(
                              leading: const Icon(Icons.badge),
                              title: const Text('Apellido'),
                              subtitle: Text(c.apellido),
                            ),
                            ListTile(
                              leading: const Icon(Icons.phone),
                              title: const Text('Teléfono'),
                              subtitle: Text(c.telefono),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          icon: const Icon(Icons.edit),
                          label: const Text('Editar'),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FormularioScreen(contacto: c),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
