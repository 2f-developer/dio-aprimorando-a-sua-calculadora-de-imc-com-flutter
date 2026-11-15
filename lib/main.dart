import 'package:flutter/material.dart';

import 'imc.dart';

void main() => runApp(const ImcApp());

const ink = Color(0xFF30251F);
const paper = Color(0xFFFAF6EF);
const rust = Color(0xFF8B3C28);

class ImcApp extends StatelessWidget {
  const ImcApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Caderno de IMC',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      fontFamily: 'DejaVuSans',
      colorScheme: ColorScheme.fromSeed(seedColor: rust),
      scaffoldBackgroundColor: paper,
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
    ),
    home: const ImcPage(),
  );
}

class ImcPage extends StatefulWidget {
  const ImcPage({super.key});
  @override
  State<ImcPage> createState() => _ImcPageState();
}

class _ImcPageState extends State<ImcPage> {
  final _form = GlobalKey<FormState>();
  final _peso = TextEditingController();
  final _altura = TextEditingController();
  final _registros = <IMC>[];
  String? _erro;

  @override
  void dispose() {
    _peso.dispose();
    _altura.dispose();
    super.dispose();
  }

  void _calcular() {
    setState(() => _erro = null);
    if (!_form.currentState!.validate()) return;
    try {
      final registro = IMC(
        peso: IMC.lerNumero(_peso.text)!,
        altura: IMC.lerNumero(_altura.text)!,
      );
      setState(() => _registros.insert(0, registro));
      FocusScope.of(context).unfocus();
    } on ArgumentError catch (erro) {
      setState(() => _erro = erro.message.toString());
    }
  }

  Widget _campo({
    required String label,
    required String hint,
    required TextEditingController controller,
    required String keyName,
  }) => TextFormField(
    key: Key(keyName),
    controller: controller,
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    textInputAction: keyName == 'peso'
        ? TextInputAction.next
        : TextInputAction.done,
    decoration: InputDecoration(labelText: label, hintText: hint),
    validator: IMC.validarMedida,
    onFieldSubmitted: keyName == 'altura' ? (_) => _calcular() : null,
  );

  String _numero(double n, [int casas = 2]) =>
      n.toStringAsFixed(casas).replaceAll('.', ',');

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                const Text(
                  'MEDIDAS / REGISTROS',
                  style: TextStyle(color: rust, letterSpacing: 2, fontSize: 12),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Caderno de IMC',
                  style: TextStyle(
                    fontFamily: 'DejaVuSerif',
                    fontSize: 40,
                    color: ink,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Informe peso e altura para calcular e guardar os resultados desta sessão.',
                ),
                const SizedBox(height: 32),
                Form(
                  key: _form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      LayoutBuilder(
                        builder: (context, box) {
                          final peso = _campo(
                            label: 'Peso (kg)',
                            hint: '70,0',
                            controller: _peso,
                            keyName: 'peso',
                          );
                          final altura = _campo(
                            label: 'Altura (m)',
                            hint: '1,70',
                            controller: _altura,
                            keyName: 'altura',
                          );
                          return box.maxWidth >= 560
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(child: peso),
                                    const SizedBox(width: 16),
                                    Expanded(child: altura),
                                  ],
                                )
                              : Column(
                                  children: [
                                    peso,
                                    const SizedBox(height: 16),
                                    altura,
                                  ],
                                );
                        },
                      ),
                      const SizedBox(height: 18),
                      FilledButton.icon(
                        key: const Key('calcular'),
                        onPressed: _calcular,
                        style: FilledButton.styleFrom(
                          backgroundColor: ink,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(54),
                        ),
                        icon: const Icon(Icons.add),
                        label: const Text('Calcular e adicionar'),
                      ),
                    ],
                  ),
                ),
                if (_erro != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(_erro!, style: const TextStyle(color: rust)),
                  ),
                const SizedBox(height: 32),
                if (_registros.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0D9C8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Semantics(
                      liveRegion: true,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'ÚLTIMO RESULTADO',
                            style: TextStyle(
                              color: rust,
                              letterSpacing: 1.5,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 8),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _numero(_registros.first.valor),
                              key: const Key('ultimo-imc'),
                              style: const TextStyle(
                                fontFamily: 'DejaVuSerif',
                                fontSize: 64,
                                color: ink,
                              ),
                            ),
                          ),
                          Text(
                            'kg/m² · ${_registros.first.classificacao.descricao}',
                            key: const Key('ultima-classificacao'),
                            style: const TextStyle(color: ink),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
                Text(
                  'Resultados · ${_registros.length}',
                  style: const TextStyle(
                    fontFamily: 'DejaVuSerif',
                    fontSize: 24,
                    color: ink,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'A lista fica disponível enquanto o app estiver aberto.',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 16),
                if (_registros.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFD7CABC)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Nenhum cálculo ainda. Preencha os campos para começar.',
                    ),
                  ),
                for (var i = 0; i < _registros.length; i++)
                  Container(
                    key: Key('registro-${_registros.length - i}'),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xFFD7CABC)),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'REGISTRO ${_registros.length - i}',
                                style: const TextStyle(
                                  color: rust,
                                  letterSpacing: 1,
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${_numero(_registros[i].peso)} kg · ${_numero(_registros[i].altura)} m',
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _registros[i].classificacao.descricao,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Flexible(
                          child: Text(
                            _numero(_registros[i].valor),
                            style: const TextStyle(
                              fontFamily: 'DejaVuSerif',
                              fontSize: 26,
                              color: ink,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
