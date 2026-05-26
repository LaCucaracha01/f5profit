import 'package:flutter/material.dart';
import 'package:profitf5/telas/treino_screen.dart';

class DadosFisicosScreen extends StatefulWidget {

  final String objetivo;

  const DadosFisicosScreen({
    super.key,
    required this.objetivo,
  });

  @override
  State<DadosFisicosScreen> createState() =>
      _DadosFisicosScreenState();
}

class _DadosFisicosScreenState
    extends State<DadosFisicosScreen> {

  final idadeController =
      TextEditingController();

  final alturaController =
      TextEditingController();

  final pesoController =
      TextEditingController();

  late String objetivoSelecionado;

  double imc = 0;

  @override
  void initState() {
    super.initState();

    objetivoSelecionado =
        widget.objetivo;
  }

  void calcularIMC() {

    double peso =
        double.tryParse(
              pesoController.text,
            ) ??
            0;

    double altura =
        double.tryParse(
              alturaController.text,
            ) ??
            0;

    if (peso > 0 && altura > 0) {

      double alturaMetros =
          altura / 100;

      setState(() {

        imc = peso /
            (alturaMetros * alturaMetros);
      });
    }
  }

  String classificacaoIMC(double imc) {

    if (imc == 0) {
      return "";
    }

    if (imc < 18.5) {
      return "Abaixo do peso";
    }

    if (imc < 25) {
      return "Peso normal";
    }

    if (imc < 30) {
      return "Sobrepeso";
    }

    return "Obesidade";
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const Text(
              "Dados\nFísicos",
              style: TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.bold,
                height: 1.1,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Objetivo: $objetivoSelecionado",
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 40),

            // IDADE
            _input(
              controller: idadeController,
              hint: "Idade",
              icon: Icons.cake_outlined,
            ),

            const SizedBox(height: 20),

            // ALTURA
            _input(
              controller: alturaController,
              hint: "Altura (cm)",
              icon: Icons.height,
              onChanged: (_) => calcularIMC(),
            ),

            const SizedBox(height: 20),

            // PESO
            _input(
              controller: pesoController,
              hint: "Peso (kg)",
              icon:
                  Icons.monitor_weight_outlined,
              onChanged: (_) => calcularIMC(),
            ),

            const SizedBox(height: 20),

            // IMC
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),

                borderRadius:
                    BorderRadius.circular(20),
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Text(
                    "IMC: ${imc.toStringAsFixed(1)}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    classificacaoIMC(imc),
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 50),

            SizedBox(
              width: double.infinity,
              height: 60,

              child: ElevatedButton(
                onPressed: () {

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) =>
          TreinoScreen(
        objetivo:
            objetivoSelecionado,
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

  Widget _input({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    Function(String)? onChanged,
  }) {

    return TextField(
      controller: controller,

      onChanged: onChanged,

      keyboardType: TextInputType.number,

      style: const TextStyle(
        color: Colors.white,
      ),

      decoration: InputDecoration(
        hintText: hint,

        hintStyle: const TextStyle(
          color: Colors.white38,
        ),

        prefixIcon: Icon(
          icon,
          color: Colors.white70,
        ),

        filled: true,
        fillColor: const Color(0xFF1A1A1A),

        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(18),

          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}