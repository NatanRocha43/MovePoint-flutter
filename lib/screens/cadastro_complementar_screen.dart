import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login_screen.dart';

class CadastroComplementarScreen extends StatefulWidget {
  final String email;
  final String senha;
  final String cep;
  final String endereco;
  final String numero;
  final String cidade;
  final String uf;

  const CadastroComplementarScreen({
    super.key,
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
  final TextEditingController _pcdController = TextEditingController();
  String? _genero;
  final TextEditingController _idadeController = TextEditingController();
  final TextEditingController _esporteController = TextEditingController();

  @override
  void dispose() {
    _pcdController.dispose();
    _idadeController.dispose();
    _esporteController.dispose();
    super.dispose();
  }

  void _finalizarCadastro() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Cadastro concluído'),
          content: const Text('Seu cadastro foi finalizado com sucesso!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
              child: const Text('OK'),
            ),
          ],
        ),
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            constraints: const BoxConstraints(maxWidth: 420),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
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

                  // Campo PCD
                  _buildDropdownField(
                    label: 'Especificação de PCD',
                    value: _pcdController.text.isEmpty ? null : _pcdController.text,
                    items: const ['Sim', 'Não'],
                    onChanged: (val) => setState(() => _pcdController.text = val ?? ''),
                    validator: (val) => val == null ? 'Selecione se é PCD' : null,
                  ),
                  const SizedBox(height: 20),

                  // Campo Gênero
                  _buildDropdownField(
                    label: 'Gênero',
                    value: _genero,
                    items: const ['Masculino', 'Feminino', 'Outro'],
                    onChanged: (val) => setState(() => _genero = val),
                    validator: (val) => val == null ? 'Selecione o gênero' : null,
                  ),
                  const SizedBox(height: 20),

                  // Campo Idade
                  _buildNumberField(
                    label: 'Idade',
                    controller: _idadeController,
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'Informe a idade';
                      final idade = int.tryParse(val);
                      if (idade == null || idade <= 0) return 'Informe uma idade válida';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Campo Esporte
                  _buildTextField(
                    label: 'Esporte de Interesse',
                    controller: _esporteController,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Informe o esporte de interesse';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // Botão de cadastro
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _finalizarCadastro,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF378274),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                      ),
                      child: const Text(
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

                  // Link de login
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
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
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 4),
          child: Text(
            label,
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
        Container(
          height: 45,
          decoration: BoxDecoration(
            color: const Color(0xFFD1F3ED),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            items: items
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: onChanged,
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
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 4),
          child: Text(
            label,
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
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
              contentPadding: EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 18,
              ),
            ),
            style: const TextStyle(color: Colors.black54),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 4),
          child: Text(
            label,
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
        Container(
          height: 45,
          decoration: BoxDecoration(
            color: const Color(0xFFD1F3ED),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextFormField(
            controller: controller,
            validator: validator,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 18,
              ),
            ),
            style: const TextStyle(color: Colors.black54),
          ),
        ),
      ],
    );
  }
}
