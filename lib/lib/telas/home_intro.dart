import 'package:flutter/material.dart';
import 'package:profitf5/telas/login.dart';

class HomeIntroScreen extends StatelessWidget {
  const HomeIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,

            crossAxisAlignment:
                CrossAxisAlignment.center,

            children: [

              // ICONE
              Container(
                height: 140,
                width: 140,

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(30),
                ),

                child: const Icon(
                  Icons.fitness_center,
                  size: 70,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 40),

              // TITULO
              const Text(
                "TREINE\nCOM PROPÓSITO!💪",
                textAlign: TextAlign.center,

                style: TextStyle(
                  color: Colors.white,
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                ),
              ),

              const SizedBox(height: 20),

              // SUBTITULO
              const Text(
                "Treinos personalizados\npara sua evolução física.",
                textAlign: TextAlign.center,

                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 60),

              // BOTAO
              SizedBox(
                width: double.infinity,
                height: 60,

                child: ElevatedButton(
                  onPressed: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const LoginScreen(),
                      ),
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,

                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20),
                    ),
                  ),

                  child: const Text(
                    "COMEÇAR",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}