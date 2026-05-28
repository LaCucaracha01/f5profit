import 'package:flutter/material.dart';
import 'package:profitf5/database/database_helper.dart';
import 'package:profitf5/telas/login.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  bool esconderSenha = true;

  bool esconderConfirmarSenha = true;

  final TextEditingController nomeController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController senhaController = TextEditingController();

  final TextEditingController confirmarSenhaController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                // LOGO
                Container(
                  height: 100,
                  width: 100,

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),

                  child: const Icon(
                    Icons.trending_up,
                    size: 50,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 30),

                // TITULO
                const Text(
                  "Criar Conta",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Cadastre-se para continuar",
                  style: TextStyle(color: Colors.white54, fontSize: 16),
                ),

                const SizedBox(height: 40),

                // NOME
                _input(
                  controller: nomeController,
                  hint: "Nome",
                  icon: Icons.person_outline,
                ),

                const SizedBox(height: 20),

                // EMAIL
                _input(
                  controller: emailController,
                  hint: "Email",
                  icon: Icons.email_outlined,
                ),

                const SizedBox(height: 20),

                // SENHA
                TextField(
                  controller: senhaController,
                  obscureText: esconderSenha,
                  style: const TextStyle(color: Colors.white),

                  decoration: InputDecoration(
                    hintText: "Senha",

                    hintStyle: const TextStyle(color: Colors.white38),

                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Colors.white70,
                    ),

                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          esconderSenha = !esconderSenha;
                        });
                      },

                      icon: Icon(
                        esconderSenha ? Icons.visibility_off : Icons.visibility,

                        color: Colors.white54,
                      ),
                    ),

                    filled: true,

                    fillColor: const Color(0xFF1A1A1A),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),

                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // CONFIRMAR SENHA
                TextField(
                  controller: confirmarSenhaController,

                  obscureText: esconderConfirmarSenha,

                  style: const TextStyle(color: Colors.white),

                  decoration: InputDecoration(
                    hintText: "Confirmar Senha",

                    hintStyle: const TextStyle(color: Colors.white38),

                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Colors.white70,
                    ),

                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          esconderConfirmarSenha = !esconderConfirmarSenha;
                        });
                      },

                      icon: Icon(
                        esconderConfirmarSenha
                            ? Icons.visibility_off
                            : Icons.visibility,

                        color: Colors.white54,
                      ),
                    ),

                    filled: true,

                    fillColor: const Color(0xFF1A1A1A),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),

                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                // BOTAO CADASTRAR
                SizedBox(
                  width: double.infinity,
                  height: 60,

                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        String nome = nomeController.text.trim();

                        String email = emailController.text.trim();

                        String senha = senhaController.text.trim();

                        String confirmarSenha = confirmarSenhaController.text
                            .trim();

                        // VALIDACAO
                        if (nome.isEmpty ||
                            email.isEmpty ||
                            senha.isEmpty ||
                            confirmarSenha.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Preencha todos os campos"),
                            ),
                          );

                          return;
                        }

                        // SENHAS
                        if (senha != confirmarSenha) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("As senhas não coincidem"),
                            ),
                          );

                          return;
                        }

                        // SALVAR SQLITE
                        await DatabaseHelper.instance.cadastrarUsuario(
                          nome,
                          email,
                          senha,
                        );

                        if (!mounted) return;

                        // MENSAGEM
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Cadastro realizado com sucesso!"),
                          ),
                        );

                        // IR LOGIN
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text("Erro: $e")));
                      }
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,

                      foregroundColor: Colors.black,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),

                    child: const Text(
                      "Cadastrar",

                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // LOGIN
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    const Text(
                      "Já possui conta?",

                      style: TextStyle(color: Colors.white54),
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },

                      child: const Text(
                        "Entrar",

                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _input({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        prefixIcon: Icon(icon, color: Colors.white70),
        filled: true,
        fillColor: const Color(0xFF1A1A1A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
