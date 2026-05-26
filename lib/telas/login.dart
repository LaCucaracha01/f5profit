import 'package:flutter/material.dart';
import 'package:profitf5/database/database_helper.dart';
import 'package:profitf5/telas/cadastro.dart';
import 'package:profitf5/telas/objetivo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool esconderSenha = true;

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController senhaController =
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
                    Icons.fitness_center,
                    size: 50,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 30),

                // TITULO
                const Text(
                  "Entrar",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Acesse sua conta",
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 40),

                // EMAIL
                TextField(
                  controller: emailController,

                  style: const TextStyle(
                    color: Colors.white,
                  ),

                  decoration: InputDecoration(
                    hintText: "Email",

                    hintStyle: const TextStyle(
                      color: Colors.white38,
                    ),

                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: Colors.white70,
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

                // SENHA
                TextField(
                  controller: senhaController,

                  obscureText: esconderSenha,

                  style: const TextStyle(
                    color: Colors.white,
                  ),

                  decoration: InputDecoration(
                    hintText: "Senha",

                    hintStyle: const TextStyle(
                      color: Colors.white38,
                    ),

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
                        esconderSenha
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

                const SizedBox(height: 15),

                // ESQUECI SENHA
                Align(
                  alignment: Alignment.centerRight,

                  child: TextButton(
                    onPressed: () {},

                    child: const Text(
                      "Esqueci minha senha",

                      style: TextStyle(
                        color: Colors.white54,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // BOTAO LOGIN
                SizedBox(
                  width: double.infinity,
                  height: 60,

                  child: ElevatedButton(
                    onPressed: () async {
                      String email =
                          emailController.text.trim();

                      String senha =
                          senhaController.text.trim();

                      // VALIDAR CAMPOS
                      if (email.isEmpty ||
                          senha.isEmpty) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Preencha todos os campos",
                            ),
                          ),
                        );

                        return;
                      }

                      // LOGIN SQLITE
                      final usuario =
                          await DatabaseHelper.instance
                              .login(
                        email,
                        senha,
                      );

                      // USUARIO EXISTE
                      if (usuario != null) {
                        if (!mounted) return;

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const ObjetivoScreen(),
                          ),
                        );
                      } else {
                        // LOGIN INVALIDO
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Email ou senha inválidos",
                            ),
                          ),
                        );
                      }
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,

                      foregroundColor: Colors.black,

                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(18),
                      ),
                    ),

                    child: const Text(
                      "Entrar",

                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // CRIAR CONTA
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,

                  children: [
                    const Text(
                      "Não possui conta?",

                      style: TextStyle(
                        color: Colors.white54,
                      ),
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const CadastroScreen(),
                          ),
                        );
                      },

                      child: const Text(
                        "Criar Conta",

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
}