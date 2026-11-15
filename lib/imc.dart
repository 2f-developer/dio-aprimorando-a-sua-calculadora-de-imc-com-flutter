import 'classificacao.dart';

class IMC {
  final double peso;
  final double altura;

  IMC({required this.peso, required this.altura}) {
    if (!peso.isFinite || peso <= 0 || !altura.isFinite || altura <= 0) {
      throw ArgumentError(
        'Peso e altura devem ser números finitos maiores que zero.',
      );
    }
    if (!valor.isFinite || valor <= 0) {
      throw ArgumentError(
        'Peso ou altura fora do intervalo numérico suportado.',
      );
    }
  }

  double get valor => peso / (altura * altura);

  ClassificacaoImc get classificacao => ClassificacaoImc.de(valor);

  static double? lerNumero(String texto) =>
      double.tryParse(texto.trim().replaceAll(',', '.'));

  static String? validarMedida(String? texto) {
    if (texto == null || texto.trim().isEmpty) return 'Preencha este campo.';
    final numero = lerNumero(texto);
    if (numero == null || !numero.isFinite || numero <= 0) {
      return 'Use um número maior que zero.';
    }
    return null;
  }
}
