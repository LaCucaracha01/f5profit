import 'package:flutter/material.dart';
import 'package:profitf5/telas/home_intro.dart';
import 'package:profitf5/telas/treino_screen.dart';
import 'package:profitf5/database/database_helper.dart';

class UsuariosScreen extends StatefulWidget {
  const UsuariosScreen({super.key});

  @override
  State<UsuariosScreen> createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  List<Map<String, dynamic>> usuarios = [];

  @override
  void initState() {
    super.initState();

    carregarUsuarios();
  }

  Future carregarUsuarios() async {
    final db = await DatabaseHelper.instance.database;

    final resultado = await db.query('usuarios');

    setState(() {
      usuarios = resultado;
    });
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const TreinoScreen(objetivo: 'Emagrecer'),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.white),
            title: const Text('Usuário', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
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
        title: const Text("Usuários"),

        backgroundColor: Colors.transparent,
      ),

      body: ListView.builder(
        itemCount: usuarios.length,

        itemBuilder: (context, index) {
          final usuario = usuarios[index];

          return Container(
            margin: const EdgeInsets.all(12),

            padding: const EdgeInsets.all(20),

            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),

              borderRadius: BorderRadius.circular(20),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  usuario['nome'],

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  usuario['email'],

                  style: const TextStyle(color: Colors.white70),
                ),

                const SizedBox(height: 8),

                Text(
                  usuario['senha'],

                  style: const TextStyle(color: Colors.white38),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
