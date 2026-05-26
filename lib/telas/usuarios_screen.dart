import 'package:flutter/material.dart';
import 'package:profitf5/database/database_helper.dart';

class UsuariosScreen extends StatefulWidget {
  const UsuariosScreen({super.key});

  @override
  State<UsuariosScreen> createState() =>
      _UsuariosScreenState();
}

class _UsuariosScreenState
    extends State<UsuariosScreen> {

  List<Map<String, dynamic>> usuarios =
      [];

  @override
  void initState() {
    super.initState();

    carregarUsuarios();
  }

  Future carregarUsuarios() async {

    final db =
        await DatabaseHelper.instance
            .database;

    final resultado =
        await db.query('usuarios');

    setState(() {

      usuarios = resultado;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
          const Color(0xFF0F0F0F),

      appBar: AppBar(
        title: const Text(
          "Usuários",
        ),

        backgroundColor:
            Colors.transparent,
      ),

      body: ListView.builder(
        itemCount: usuarios.length,

        itemBuilder: (context, index) {

          final usuario =
              usuarios[index];

          return Container(
            margin:
                const EdgeInsets.all(12),

            padding:
                const EdgeInsets.all(20),

            decoration: BoxDecoration(
              color:
                  const Color(0xFF1A1A1A),

              borderRadius:
                  BorderRadius.circular(
                      20),
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  usuario['nome'],

                  style:
                      const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  usuario['email'],

                  style:
                      const TextStyle(
                    color:
                        Colors.white70,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  usuario['senha'],

                  style:
                      const TextStyle(
                    color:
                        Colors.white38,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}