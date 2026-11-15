import 'package:flutter_test/flutter_test.dart';
import 'package:imc_app/imc.dart';

void main() {
  test('calcula o IMC preservando a precisão', () {
    expect(
      IMC(peso: 70, altura: 1.7).valor,
      closeTo(24.221453287197235, 1e-12),
    );
  });
  test(
    'valida números localizados sem aceitar vazio ou valores não finitos',
    () {
      expect(IMC.lerNumero(' 1,70 '), 1.7);
      expect(IMC.lerNumero('1.70'), 1.7);
      for (final valor in ['', ' ', 'zero', '-1', '0', 'NaN', 'Infinity']) {
        expect(IMC.validarMedida(valor), isNotNull);
      }
      expect(IMC.validarMedida('70,5'), isNull);
    },
  );
  test('protege o domínio e o cálculo contra números inválidos', () {
    for (final valor in [0.0, -1.0, double.nan, double.infinity]) {
      expect(() => IMC(peso: valor, altura: 1.7), throwsArgumentError);
      expect(() => IMC(peso: 70, altura: valor), throwsArgumentError);
    }
    expect(() => IMC(peso: 70, altura: 1e-200), throwsArgumentError);
    expect(() => IMC(peso: 70, altura: 1e200), throwsArgumentError);
  });
}
