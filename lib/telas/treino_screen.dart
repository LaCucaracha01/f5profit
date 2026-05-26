import 'package:flutter/material.dart';

class TreinoScreen extends StatefulWidget {

  final String objetivo;

  const TreinoScreen({
    super.key,
    required this.objetivo,
  });

  @override
  State<TreinoScreen> createState() =>
      _TreinoScreenState();
}

class _TreinoScreenState
    extends State<TreinoScreen> {

  List<Map<String, dynamic>> treino = [];

  @override
  void initState() {
    super.initState();

    gerarTreino();
  }

  void gerarTreino() {

    if (widget.objetivo == "Emagrecer") {

      treino = [

        {
          "dia": "Treino A",
          "exercicio": "Esteira",
          "series": "20 min",
        },

        {
          "dia": "Treino B",
          "exercicio": "Agachamento",
          "series": "4x15",
        },

        {
          "dia": "Treino C",
          "exercicio": "Burpee",
          "series": "4x12",
        },
      ];
    }

    else if (widget.objetivo ==
        "Ganhar Massa") {

      treino = [

        {
          "dia": "Treino A",
          "exercicio": "Supino Reto",
          "series": "4x10",
        },

        {
          "dia": "Treino B",
          "exercicio": "Agachamento Livre",
          "series": "4x10",
        },

        {
          "dia": "Treino C",
          "exercicio": "Levantamento Terra",
          "series": "4x8",
        },
      ];
    }

    else if (widget.objetivo ==
        "Definição") {

      treino = [

        {
          "dia": "Treino A",
          "exercicio": "Corrida",
          "series": "25 min",
        },

        {
          "dia": "Treino B",
          "exercicio": "Flexão",
          "series": "4x20",
        },

        {
          "dia": "Treino C",
          "exercicio": "Abdominal",
          "series": "4x25",
        },
      ];
    }

    else {

      treino = [

        {
          "dia": "Treino A",
          "exercicio": "Bicicleta",
          "series": "20 min",
        },

        {
          "dia": "Treino B",
          "exercicio": "Pular Corda",
          "series": "15 min",
        },

        {
          "dia": "Treino C",
          "exercicio": "Corrida",
          "series": "30 min",
        },
      ];
    }
  }

  void excluirTreino(int index) {

    setState(() {

      treino.removeAt(index);
    });
  }

  void editarTreino(int index) {

    TextEditingController controller =
        TextEditingController(
      text: treino[index]["exercicio"],
    );

    showDialog(
      context: context,

      builder: (context) {

        return AlertDialog(

          backgroundColor:
              const Color(0xFF1A1A1A),

          title: const Text(
            "Editar Exercício",
            style: TextStyle(
              color: Colors.white,
            ),
          ),

          content: TextField(
            controller: controller,

            style: const TextStyle(
              color: Colors.white,
            ),

            decoration: InputDecoration(
              hintText: "Novo exercício",

              hintStyle: const TextStyle(
                color: Colors.white38,
              ),
            ),
          ),

          actions: [

            TextButton(
              onPressed: () {

                Navigator.pop(context);
              },

              child: const Text(
                "Cancelar",
              ),
            ),

            TextButton(
              onPressed: () {

                setState(() {

                  treino[index]["exercicio"] =
                      controller.text;
                });

                Navigator.pop(context);
              },

              child: const Text(
                "Salvar",
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
          const Color(0xFF0F0F0F),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        title: Text(
          widget.objetivo,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: ListView.builder(
          itemCount: treino.length,

          itemBuilder: (context, index) {

            final item = treino[index];

            return Container(
              margin:
                  const EdgeInsets.only(
                bottom: 20,
              ),

              padding:
                  const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color:
                    const Color(0xFF1A1A1A),

                borderRadius:
                    BorderRadius.circular(
                        24),
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Text(
                    item["dia"],

                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight:
                          FontWeight.bold,
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
                    mainAxisAlignment:
                        MainAxisAlignment.end,

                    children: [

                      IconButton(
                        onPressed: () {

                          editarTreino(index);
                        },

                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),

                      IconButton(
                        onPressed: () {

                          excluirTreino(index);
                        },

                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),

      floatingActionButton:
          FloatingActionButton(
        backgroundColor: Colors.white,

        onPressed: () {

          setState(() {

            treino.add({

              "dia":
                  "Novo Treino",

              "exercicio":
                  "Novo Exercício",

              "series":
                  "3x12",
            });
          });
        },

        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}