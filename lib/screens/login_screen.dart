import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:nome_do_projeto/screens/feed.dart';
import 'cadastro_basico_screen.dart';

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
      MaterialPageRoute(builder: (context) => const CadastroParte1Screen()),
    );
  }

  void _navegarParaFeed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FeedPage()),
    );
  }

  void _fazerLogin() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _senhaController.text.trim(),
        );
        _mostrarDialogo('Sucesso', 'Login realizado com sucesso!');
        _navegarParaFeed();
      } on FirebaseAuthException catch (e) {
        String mensagemErro = 'Erro ao fazer login.';
        if (e.code == 'user-not-found') {
          mensagemErro = 'Usuário não encontrado.';
        } else if (e.code == 'wrong-password') {
          mensagemErro = 'Senha incorreta.';
        }
        _mostrarDialogo('Erro', mensagemErro);
      } catch (e) {
        _mostrarDialogo('Erro', 'Ocorreu um erro inesperado.');
      }
    }
  }

  void _mostrarDialogo(String titulo, String mensagem) {
    showDialog(
      context: context,
      builder:
          (BuildContext context) => AlertDialog(
            title: Text(titulo),
            content: Text(mensagem),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
    );
  }

  Future<void> _loginComGoogle() async {
    try {
      if (kIsWeb) {
        await FirebaseAuth.instance.signInWithPopup(GoogleAuthProvider());
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) return;

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
      }

      _mostrarDialogo('Sucesso', 'Login com Google realizado!');
      _navegarParaFeed();
    } catch (e) {
      _mostrarDialogo('Erro', 'Erro ao fazer login com Google: $e');
    }
  }

  Future<void> _loginComFacebook() async {
    try {
      if (kIsWeb) {
        await FirebaseAuth.instance.signInWithPopup(FacebookAuthProvider());
      } else {
        final LoginResult result = await FacebookAuth.instance.login();
        if (result.status == LoginStatus.success) {
          final OAuthCredential credential = FacebookAuthProvider.credential(
            result.accessToken!.token,
          );
          await FirebaseAuth.instance.signInWithCredential(credential);
        } else {
          _mostrarDialogo(
            'Erro',
            'Erro ao fazer login com Facebook: ${result.message}',
          );
          return;
        }
      }

      _mostrarDialogo('Sucesso', 'Login com Facebook realizado!');
      _navegarParaFeed();
    } catch (e) {
      _mostrarDialogo('Erro', 'Erro ao fazer login com Facebook: $e');
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
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Image.asset(
                      'assets/logo.png',
                      width: 243,
                      height: 78,
                    ),
                  ),
                  const Text(
                    'Bem vindo!',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(_emailController, 'Email', false),
                  const SizedBox(height: 20),
                  _buildTextField(_senhaController, 'Senha', true),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _navegarParaCadastro,
                    child: const Text(
                      'Ainda não tem uma conta? Cadastre aqui',
                      style: TextStyle(
                        color: Color(0xFF378274),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildLoginButton(),
                  const SizedBox(height: 30),
                  Row(
                    children: const [
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildSocialButton(
                        icon: Icons.g_mobiledata,
                        color: const Color(0xFF469F8F),
                        onPressed: _loginComGoogle,
                      ),
                      _buildSocialButton(
                        icon: Icons.facebook,
                        color: const Color(0xFF469F8F),
                        onPressed: _loginComFacebook,
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

  Widget _buildTextField(
    TextEditingController controller,
    String hintText,
    bool isPassword,
  ) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFFD1F3ED),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black54),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 18,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Campo obrigatório';
          if (!isPassword && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
            return 'Email inválido';
          }
          if (isPassword && value.length < 6) return 'Senha muito curta';
          return null;
        },
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
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
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 62,
        height: 62,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.white, size: 30),
      ),
    );
  }
}
