import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 40.0, bottom: 10.0),
      height: 200,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color.fromRGBO(18, 59, 102, 1), // Azul Escuro
            Color.fromRGBO(0, 0, 0, 1), // Preto
            Color.fromRGBO(14, 87, 43, 1) // Verde Escuro
          ],
        ),
      ),
      child: Image(
        image: const AssetImage("assets/images/logo.png"),
        errorBuilder: (e, _, __) {
          return const SizedBox();
        },
      ),
    );
  }
}
