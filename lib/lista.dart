import 'package:flutter/material.dart';
import 'database.dart';
import 'form.dart';

class ReceitaListScreen extends StatefulWidget {
  const ReceitaListScreen({super.key});

  @override
  State<ReceitaListScreen> createState() => _ReceitaListScreenState();
}

class _ReceitaListScreenState extends State<ReceitaListScreen> {
  List<Map<String, dynamic>> _receitas = [];
  final dbHelper = DatabaseHelper();

  void _atualizarReceitas() async {
    final dados = await dbHelper.buscarReceitas();
    setState(() {
      _receitas = dados;
    });
  }

  @override
  void initState() {
    super.initState();
    _atualizarReceitas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Livro de Receitas')),
      body: _receitas.isEmpty
          ? const Center(child: Text('Nenhuma receita cadastrada.'))
          : ListView.builder(
              itemCount: _receitas.length,
              itemBuilder: (context, index) {
                final receita = _receitas[index];
                return ListTile(
                  leading: const Icon(
                    Icons.restaurant_menu,
                    color: Colors.orange,
                  ),
                  title: Text(
                    receita['titulo'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Ingredientes: ${receita['ingredientes']}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ReceitaFormScreen(receita: receita),
                      ),
                    );
                    _atualizarReceitas();
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ReceitaFormScreen()),
          );
          _atualizarReceitas();
        },
      ),
    );
  }
}
