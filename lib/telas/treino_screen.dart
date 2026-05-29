import 'package:flutter/material.dart';
import 'package:profitf5/database/database_helper.dart';
import 'package:profitf5/session/user_session.dart';
import 'package:profitf5/telas/home_intro.dart';
import 'package:profitf5/telas/perfil_screen.dart';

class TreinoScreen extends StatefulWidget {
  final String objetivo;

  const TreinoScreen({super.key, required this.objetivo});

  @override
  State<TreinoScreen> createState() => _TreinoScreenState();
}

class _TreinoScreenState extends State<TreinoScreen> {
  List<Map<String, dynamic>> treino = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();

    carregarTreinos();
  }

  Future<void> carregarTreinos() async {
    final usuarioId = UserSession.currentUserId;
    final defaults = gerarTreino();

    if (usuarioId == null) {
      setState(() {
        treino = defaults;
        carregando = false;
      });
      return;
    }

    final saved = await DatabaseHelper.instance.getTreinosPorUsuario(
      usuarioId,
      widget.objetivo,
    );

    if (saved.isEmpty) {
      final itens = <Map<String, dynamic>>[];
      for (final item in defaults) {
        final id = await DatabaseHelper.instance.inserirTreino(
          usuarioId,
          widget.objetivo,
          item['dia'] as String,
          item['exercicio'] as String,
          item['series'] as String,
        );
        itens.add({
          'id': id,
          'dia': item['dia'],
          'exercicio': item['exercicio'],
          'series': item['series'],
        });
      }
      setState(() {
        treino = itens;
        carregando = false;
      });
    } else {
      setState(() {
        treino = saved;
        carregando = false;
      });
    }
  }

  List<Map<String, dynamic>> gerarTreino() {
    if (widget.objetivo == "Emagrecer") {
      return [
        {"dia": "Treino A", "exercicio": "Esteira", "series": "20 min"},

        {"dia": "Treino B", "exercicio": "Agachamento", "series": "4x15"},

        {"dia": "Treino C", "exercicio": "Burpee", "series": "4x12"},
      ];
    } else if (widget.objetivo == "Ganhar Massa") {
      return [
        {"dia": "Treino A", "exercicio": "Supino Reto", "series": "4x10"},

        {"dia": "Treino B", "exercicio": "Agachamento Livre", "series": "4x10"},

        {"dia": "Treino C", "exercicio": "Levantamento Terra", "series": "4x8"},
      ];
    } else if (widget.objetivo == "Definição") {
      return [
        {"dia": "Treino A", "exercicio": "Corrida", "series": "25 min"},

        {"dia": "Treino B", "exercicio": "Flexão", "series": "4x20"},

        {"dia": "Treino C", "exercicio": "Abdominal", "series": "4x25"},
      ];
    } else {
      return [
        {"dia": "Treino A", "exercicio": "Bicicleta", "series": "20 min"},

        {"dia": "Treino B", "exercicio": "Pular Corda", "series": "15 min"},

        {"dia": "Treino C", "exercicio": "Corrida", "series": "30 min"},
      ];
    }
  }

  void excluirTreino(int index) async {
    final item = treino[index];
    final id = item['id'] as int?;

    if (id != null) {
      await DatabaseHelper.instance.excluirTreino(id);
    }

    setState(() {
      treino.removeAt(index);
    });
  }

  void editarTreino(int index) {
    TextEditingController tituloController = TextEditingController(
      text: treino[index]["dia"],
    );
    TextEditingController exercicioController = TextEditingController(
      text: treino[index]["exercicio"],
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          title: const Text(
            "Editar treino",
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tituloController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Título do treino",
                  hintStyle: const TextStyle(color: Colors.white38),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: exercicioController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Exercício",
                  hintStyle: const TextStyle(color: Colors.white38),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                final novoTitulo = tituloController.text.trim();
                final novoExercicio = exercicioController.text.trim();
                final item = treino[index];
                final id = item['id'] as int?;

                setState(() {
                  treino[index]['dia'] = novoTitulo;
                  treino[index]['exercicio'] = novoExercicio;
                });

                if (id != null) {
                  await DatabaseHelper.instance.atualizarTreino(
                    id,
                    dia: novoTitulo,
                    exercicio: novoExercicio,
                  );
                }

                Navigator.pop(context);
              },
              child: const Text("Salvar"),
            ),
          ],
        );
      },
    );
  }

  Future<void> adicionarTreino() async {
    final controller = TextEditingController(text: 'Novo Treino');

    final titulo = await showDialog<String?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          title: const Text(
            'Título do treino',
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Digite o título do treino',
              hintStyle: const TextStyle(color: Colors.white38),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, controller.text.trim());
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );

    if (titulo == null || titulo.isEmpty) return;

    final usuarioId = UserSession.currentUserId;
    if (usuarioId != null) {
      final id = await DatabaseHelper.instance.inserirTreino(
        usuarioId,
        widget.objetivo,
        titulo,
        'Novo Exercício',
        '3x12',
      );

      setState(() {
        treino.add({
          'id': id,
          'dia': titulo,
          'exercicio': 'Novo Exercício',
          'series': '3x12',
        });
      });
    } else {
      setState(() {
        treino.add({
          'dia': titulo,
          'exercicio': 'Novo Exercício',
          'series': '3x12',
        });
      });
    }
  }

  Drawer buildAppDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFF0F0F0F),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF1A1A1A)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Navegação principal',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home, color: Colors.white),
            title: const Text('Home', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeIntroScreen(),
                ),
                (route) => false,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.fitness_center, color: Colors.white),
            title: const Text('Treinos', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.white),
            title: const Text('Usuário', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PerfilScreen()),
              );
            },
          ),
          const Divider(color: Colors.white24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Todos os direitos reservados à empresa F5Profit',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  'Em memória do nosso bbzinho',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      drawer: buildAppDrawer(),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        title: Text(
          widget.objetivo,
          style: const TextStyle(color: Colors.white),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: carregando
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: treino.length,

                itemBuilder: (context, index) {
                  final item = treino[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 20),

                    padding: const EdgeInsets.all(20),

                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),

                      borderRadius: BorderRadius.circular(24),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          item["dia"],

                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          item["exercicio"],

                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          item["series"],

                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,

                          children: [
                            IconButton(
                              onPressed: () {
                                editarTreino(index);
                              },

                              icon: const Icon(Icons.edit, color: Colors.white),
                            ),

                            IconButton(
                              onPressed: () {
                                excluirTreino(index);
                              },

                              icon: const Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,

        onPressed: adicionarTreino,

        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
