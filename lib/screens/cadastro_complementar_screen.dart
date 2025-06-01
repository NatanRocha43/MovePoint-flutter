import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nome_do_projeto/sports/index.dart';

import 'login_screen.dart';

class CadastroComplementarScreen extends StatefulWidget {
  final String nome;
  final String email;
  final String senha;
  final String cep;
  final String endereco;
  final String numero;
  final String cidade;
  final String uf;

  const CadastroComplementarScreen({
    super.key,
    required this.nome,
    required this.email,
    required this.senha,
    required this.cep,
    required this.endereco,
    required this.numero,
    required this.cidade,
    required this.uf,
  });

  @override
  State<CadastroComplementarScreen> createState() =>
      _CadastroComplementarScreenState();
}

class _CadastroComplementarScreenState
    extends State<CadastroComplementarScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _pcd;
  String? _genero;
  String? _esporte;
  final TextEditingController _idadeController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _idadeController.dispose();
    super.dispose();
  }

  Future<UserCredential> _criarUsuarioFirebase() async {
    return await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: widget.email,
      password: widget.senha,
    );
  }

  Future<void> _salvarDadosFirestore(String uid) async {
    await FirebaseFirestore.instance.collection('usuarios').doc(uid).set({
      'nome': widget.nome,
      'email': widget.email,
      'cep': widget.cep,
      'endereco': widget.endereco,
      'numero': widget.numero,
      'cidade': widget.cidade,
      'uf': widget.uf,
      'pcd': _pcd,
      'genero': _genero,
      'idade': int.tryParse(_idadeController.text) ?? 0,
      'esporte': _esporte,
      'criado_em': FieldValue.serverTimestamp(),
    });
  }

  void _mostrarConfirmacao() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Cadastro concluído'),
            content: const Text('Seu cadastro foi finalizado com sucesso!'),
            actions: [
              TextButton(
                onPressed:
                    () => Navigator.of(
                      context,
                    ).popUntil((route) => route.isFirst),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  Future<void> _finalizarCadastro() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final userCredential = await _criarUsuarioFirebase();
      await _salvarDadosFirestore(userCredential.user!.uid);
      _mostrarConfirmacao();
    } on FirebaseAuthException catch (e) {
      String msg = 'Erro ao cadastrar usuário';
      if (e.code == 'email-already-in-use') {
        msg = 'Este e-mail já está em uso.';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro inesperado: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            constraints: const BoxConstraints(maxWidth: 420),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/logo.png',
                      width: 220,
                      height: 70,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 32),

                  _buildDropdownField(
                    label: 'Especificação de PCD',
                    value: _pcd,
                    items: const ['Sim', 'Não'],
                    onChanged: (val) => setState(() => _pcd = val),
                    validator:
                        (val) => val == null ? 'Selecione se é PCD' : null,
                  ),
                  const SizedBox(height: 20),

                  _buildDropdownField(
                    label: 'Gênero',
                    value: _genero,
                    items: const ['Masculino', 'Feminino', 'Outro'],
                    onChanged: (val) => setState(() => _genero = val),
                    validator:
                        (val) => val == null ? 'Selecione o gênero' : null,
                  ),
                  const SizedBox(height: 20),

                  _buildNumberField(
                    label: 'Idade',
                    controller: _idadeController,
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'Informe a idade';
                      final idade = int.tryParse(val);
                      if (idade == null || idade <= 0)
                        return 'Informe uma idade válida';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  _buildDropdownField(
                    label: 'Esporte de Interesse',
                    value: _esporte,
                    items: esportesPopulares,
                    onChanged: (val) => setState(() => _esporte = val),
                    validator:
                        (val) =>
                            val == null
                                ? 'Selecione o esporte de interesse'
                                : null,
                  ),
                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _finalizarCadastro,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF378274),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                      ),
                      child:
                          _isLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text(
                                'Cadastrar',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      child: const Text(
                        'Já possui uma conta? Faça o login aqui.',
                        style: TextStyle(
                          color: Color(0xFF378274),
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.black, fontSize: 16)),
        Container(
          height: 45,
          decoration: BoxDecoration(
            color: const Color(0xFFD1F3ED),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            items:
                items
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
            onChanged: onChanged,
            icon: const Icon(Icons.arrow_drop_down, color: Colors.black54),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
            validator: validator,
            style: const TextStyle(color: Colors.black54),
          ),
        ),
      ],
    );
  }

  Widget _buildNumberField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.black, fontSize: 16)),
        Container(
          height: 45,
          decoration: BoxDecoration(
            color: const Color(0xFFD1F3ED),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: validator,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 18),
            ),
            style: const TextStyle(color: Colors.black54),
          ),
        ),
      ],
    );
  }
}
