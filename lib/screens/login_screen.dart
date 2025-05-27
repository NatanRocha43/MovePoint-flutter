import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        // Centraliza horizontalmente e verticalmente
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            constraints: BoxConstraints(
              maxWidth: 400, // opcional, para limitar a largura em telas grandes
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Centraliza verticalmente
              crossAxisAlignment: CrossAxisAlignment.start, // Alinha à esquerda
              mainAxisSize: MainAxisSize.min, // Coluna só ocupa o espaço do conteúdo
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12), // espaçamento reduzido
                  child: Center(
                    child: Image.asset(
                      'assets/logo.png',
                      width: 243,
                      height: 78, // preenche o container para evitar espaços brancos
                    ),
                  ),
                ),

                const Text(
                  'Bem vindo!',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20), // menos espaçamento entre texto e input

                // Campo email
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color(0xFFD1F3ED),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Email',
                      hintStyle: TextStyle(color: Colors.black54),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 18,
                      ),
                    ),
                    textAlignVertical: TextAlignVertical.center, // centraliza verticalmente
                  ),
                ),
                const SizedBox(height: 20),

                // Campo senha
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color(0xFFD1F3ED),
                  ),
                  child: const TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Senha',
                      hintStyle: TextStyle(color: Colors.black54),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 18,
                      ),
                    ),
                    textAlignVertical: TextAlignVertical.center, // centraliza verticalmente
                  ),
                ),
                const SizedBox(height: 12),

                // Texto cadastro abaixo da senha
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      // ação de cadastro
                    },
                    child: const Text(
                      'Ainda não tem uma conta? Cadastre aqui',
                      style: TextStyle(
                        color: Color(0xFF378274),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Botão de login
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF378274),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      // ação de login
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Linha com "OU"
                Row(
                  children: <Widget>[
                    Expanded(child: Divider(color: Colors.black54)),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'OU',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.black54)),
                  ],
                ),

                const SizedBox(height: 30),

                // Botões sociais
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildSocialButton(
                      icon: Icons.g_mobiledata,
                      color: const Color(0xFF469F8F),
                    ),
                    _buildSocialButton(
                      icon: Icons.facebook,
                      color: const Color(0xFF469F8F),
                    ),
                    _buildSocialButton(
                      icon: Icons.apple,
                      color: const Color(0xFF469F8F),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({required IconData icon, required Color color}) {
    return Container(
      width: 62,
      height: 62,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: Colors.white, size: 30),
    );
  }
}
