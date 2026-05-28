import 'package:flutter/material.dart';
import 'package:profitf5/database/database_helper.dart';
import 'package:profitf5/session/user_session.dart';
import 'package:profitf5/telas/login.dart';
import 'package:profitf5/telas/home_intro.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  Map<String, dynamic>? usuario;
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarUsuario();
  }

  Future<void> carregarUsuario() async {
    setState(() {
      carregando = true;
    });

    final id = UserSession.currentUserId;

    if (id == null) {
      setState(() {
        usuario = null;
        carregando = false;
      });
      return;
    }

    final data = await DatabaseHelper.instance.getUsuarioById(id);

    setState(() {
      usuario = data;
      carregando = false;
    });
  }

  Future<void> editarCampo(String campo, String label) async {
    final controller = TextEditingController(
      text: usuario?[campo]?.toString() ?? '',
    );

    final result = await showDialog<String?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Alterar $label'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Novo $label'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );

    if (result == null || result.isEmpty) return;

    final id = UserSession.currentUserId;
    if (id == null) return;

    try {
      if (campo == 'nome') {
        await DatabaseHelper.instance.atualizarUsuario(id, nome: result);
      } else if (campo == 'email') {
        await DatabaseHelper.instance.atualizarUsuario(id, email: result);
      } else if (campo == 'senha') {
        await DatabaseHelper.instance.atualizarUsuario(id, senha: result);
      } else if (campo == 'idade') {
        final int? v = int.tryParse(result);
        if (v == null) throw 'Idade inválida';
        await DatabaseHelper.instance.atualizarUsuario(id, idade: v);
      } else if (campo == 'peso') {
        final double? v = double.tryParse(result.replaceAll(',', '.'));
        if (v == null) throw 'Peso inválido';
        await DatabaseHelper.instance.atualizarUsuario(id, peso: v);
      } else if (campo == 'altura') {
        final double? v = double.tryParse(result.replaceAll(',', '.'));
        if (v == null) throw 'Altura inválida';
        await DatabaseHelper.instance.atualizarUsuario(id, altura: v);
      }

      await carregarUsuario();

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Atualizado com sucesso')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao atualizar: $e')));
    }
  }

  Future<void> excluirConta() async {
    final confirm = await showDialog<bool?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir conta'),
          content: const Text(
            'Tem certeza que deseja excluir sua conta? Isso não pode ser desfeito.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Excluir', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    final id = UserSession.currentUserId;
    if (id == null) return;

    await DatabaseHelper.instance.excluirUsuario(id);

    UserSession.clear();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Perfil', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: carregando
            ? const Center(child: CircularProgressIndicator())
            : usuario == null
            ? const Center(
                child: Text(
                  'Usuário não encontrado',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nome: ${usuario!['nome']}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'E-mail: ${usuario!['email']}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Senha: ${usuario!['senha']}',
                          style: const TextStyle(color: Colors.white38),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Idade: ${usuario!['idade'] ?? '-'}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Peso: ${usuario!['peso'] ?? '-'}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Altura: ${usuario!['altura'] ?? '-'}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () => editarCampo('nome', 'nome'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Alterar nome'),
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: () => editarCampo('email', 'e-mail'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Alterar e-mail'),
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: () => editarCampo('senha', 'senha'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Alterar senha'),
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: () => editarCampo('idade', 'idade'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Alterar idade'),
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: () => editarCampo('peso', 'peso (kg)'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Alterar peso'),
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: () => editarCampo('altura', 'altura (cm)'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Alterar altura'),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: excluirConta,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Excluir conta'),
                  ),
                  const SizedBox(height: 20),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeIntroScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.home, color: Colors.white),
                    label: const Text(
                      'Home',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
