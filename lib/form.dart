import 'package:flutter/material.dart';
import 'database.dart';

class ReceitaFormScreen extends StatefulWidget {
  final Map<String, dynamic>? receita;

  const ReceitaFormScreen({super.key, this.receita});

  @override
  State<ReceitaFormScreen> createState() => _ReceitaFormScreenState();
}

class _ReceitaFormScreenState extends State<ReceitaFormScreen> {
  final _tituloController = TextEditingController();
  final _ingredientesController = TextEditingController();
  final _preparoController = TextEditingController();

  final dbHelper = DatabaseHelper();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    if (widget.receita != null) {
      _isEditing = true;
      _tituloController.text = widget.receita!['titulo'];
      _ingredientesController.text = widget.receita!['ingredientes'];
      _preparoController.text = widget.receita!['preparo'];
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _ingredientesController.dispose();
    _preparoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Receita' : 'Nova Receita'),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                final id = widget.receita?['id'];
                if (id != null) {
                  await dbHelper.deletarReceita(id);
                }
                if (context.mounted) Navigator.pop(context);
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: 'Nome da Receita',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _ingredientesController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Ingredientes necessários',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _preparoController,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: 'Modo de Preparo / Instruções',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () async {
                final t = _tituloController.text;
                final i = _ingredientesController.text;
                final p = _preparoController.text;

                if (t.isNotEmpty && i.isNotEmpty && p.isNotEmpty) {
                  if (_isEditing) {
                    await dbHelper.atualizarReceita(
                      widget.receita!['id'],
                      t,
                      i,
                      p,
                    );
                  } else {
                    await dbHelper.inserirReceita(t, i, p);
                  }
                  if (context.mounted) Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, preencha todos os 3 campos.'),
                    ),
                  );
                }
              },
              child: Text(
                _isEditing ? 'Atualizar Receita' : 'Salvar Receita',
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
