import 'package:flutter/material.dart';
import 'package:profitf5/telas/dados_fisicos.dart';

class ObjetivoScreen extends StatefulWidget {
  const ObjetivoScreen({super.key});

  @override
  State<ObjetivoScreen> createState() =>
      _ObjetivoScreenState();
}

class _ObjetivoScreenState
    extends State<ObjetivoScreen> {

  int selecionado = -1;

  final List objetivos = [

    {
      "titulo": "Emagrecer",
      "icone": Icons.local_fire_department,
    },

    {
      "titulo": "Ganhar Massa",
      "icone": Icons.fitness_center,
    },

    {
      "titulo": "Definição",
      "icone": Icons.bolt,
    },

    {
      "titulo": "Condicionamento",
      "icone": Icons.directions_run,
    },
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const Text(
              "Qual é\nseu objetivo?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.bold,
                height: 1.1,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Escolha uma opção",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 40),

            Expanded(
              child: ListView.builder(
                itemCount: objetivos.length,

                itemBuilder: (context, index) {

                  final objetivo =
                      objetivos[index];

                  bool ativo =
                      selecionado == index;

                  return GestureDetector(

                    onTap: () {

                      setState(() {
                        selecionado = index;
                      });
                    },

                    child: AnimatedContainer(
                      duration:
                          const Duration(
                        milliseconds: 200,
                      ),

                      margin:
                          const EdgeInsets.only(
                        bottom: 20,
                      ),

                      padding:
                          const EdgeInsets.all(20),

                      decoration: BoxDecoration(
                        color: ativo
                            ? Colors.white
                            : const Color(
                                0xFF1A1A1A),

                        borderRadius:
                            BorderRadius.circular(
                                24),
                      ),

                      child: Row(
                        children: [

                          Icon(
                            objetivo["icone"],

                            color: ativo
                                ? Colors.black
                                : Colors.white,

                            size: 32,
                          ),

                          const SizedBox(width: 20),

                          Text(
                            objetivo["titulo"],

                            style: TextStyle(
                              color: ativo
                                  ? Colors.black
                                  : Colors.white,

                              fontSize: 18,

                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(
              width: double.infinity,
              height: 60,

              child: ElevatedButton(

                onPressed: () {

                  if (selecionado == -1) {

                    ScaffoldMessenger.of(context)
                        .showSnackBar(

                      const SnackBar(
                        content: Text(
                          "Escolha um objetivo",
                        ),
                      ),
                    );

                    return;
                  }

                  String objetivoEscolhido =
                      objetivos[selecionado]
                          ["titulo"];

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DadosFisicosScreen(
                        objetivo:
                            objetivoEscolhido,
                      ),
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
                  "CONTINUAR",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}