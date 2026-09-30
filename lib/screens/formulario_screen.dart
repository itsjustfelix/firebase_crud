import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/contacto.dart';
import '../services/contacto_service.dart';

/// Sirve para agregar (contacto == null) y para editar (contacto != null).
class FormularioScreen extends StatefulWidget {
  final Contacto? contacto;

  const FormularioScreen({super.key, this.contacto});

  @override
  State<FormularioScreen> createState() => _FormularioScreenState();
}

class _FormularioScreenState extends State<FormularioScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = ContactoService();

  late final TextEditingController _nombre;
  late final TextEditingController _apellido;
  late final TextEditingController _telefono;

  bool _guardando = false;
  bool get _esEdicion => widget.contacto != null;

  @override
  void initState() {
    super.initState();
    _nombre = TextEditingController(text: widget.contacto?.nombre);
    _apellido = TextEditingController(text: widget.contacto?.apellido);
    _telefono = TextEditingController(text: widget.contacto?.telefono);
  }

  @override
  void dispose() {
    _nombre.dispose();
    _apellido.dispose();
    _telefono.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _guardando = true);

    final c = Contacto(
      id: widget.contacto?.id,
      nombre: _nombre.text.trim(),
      apellido: _apellido.text.trim(),
      telefono: _telefono.text.trim(),
    );

    try {
      if (_esEdicion) {
        await _service.actualizar(c);
      } else {
        await _service.crear(c);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() => _guardando = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al guardar: $e')));
      }
    }
  }

  String? _requerido(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Campo obligatorio' : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_esEdicion ? 'Editar contacto' : 'Nuevo contacto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombre,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
                validator: _requerido,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _apellido,
                decoration: const InputDecoration(
                  labelText: 'Apellido',
                  prefixIcon: Icon(Icons.badge),
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
                validator: _requerido,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _telefono,
                decoration: const InputDecoration(
                  labelText: 'Teléfono',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Campo obligatorio';
                  if (v.trim().length < 7) return 'Mínimo 7 dígitos';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                icon: _guardando
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: Text(_esEdicion ? 'Guardar cambios' : 'Guardar'),
                onPressed: _guardando ? null : _guardar,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
