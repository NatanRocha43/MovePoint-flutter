import 'package:flutter/material.dart';
import 'cadastro_basico_screen.dart'; // ajuste o caminho conforme seu projeto

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  void _navegarParaCadastro() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CadastroParte1Screen(),
      ),
    );
  }

  void _fazerLogin() {
    if (_formKey.currentState!.validate()) {
      // Aqui você pode colocar a lógica de autenticação
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login realizado com sucesso!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Center(
                      child: Image.asset(
                        'assets/logo.png',
                        width: 243,
                        height: 78,
                      ),
                    ),
                  ),
                  const Text(
                    'Bem vindo!',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // Campo email
                  Container(
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0xFFD1F3ED),
                    ),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Email',
                        hintStyle: TextStyle(color: Colors.black54),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 18),
                      ),
                      textAlignVertical: TextAlignVertical.center,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe o email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Email inválido';
                        }
                        return null;
                      },
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
                    child: TextFormField(
                      controller: _senhaController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Senha',
                        hintStyle: TextStyle(color: Colors.black54),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 18),
                      ),
                      textAlignVertical: TextAlignVertical.center,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe a senha';
                        }
                        if (value.length < 6) {
                          return 'Senha muito curta';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Texto cadastro abaixo da senha
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: _navegarParaCadastro,
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
                      onPressed: _fazerLogin,
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
                    children: const <Widget>[
                      Expanded(child: Divider(color: Colors.black54)),
                      Padding(
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
