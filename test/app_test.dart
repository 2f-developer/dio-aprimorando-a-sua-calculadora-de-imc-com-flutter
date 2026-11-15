import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imc_app/main.dart';

void main() {
  testWidgets(
    'valida entrada e adiciona resultados à lista preservando o anterior',
    (tester) async {
      await tester.pumpWidget(const ImcApp());
      final botao = find.byKey(const Key('calcular'));
      await tester.ensureVisible(botao);
      await tester.tap(botao);
      await tester.pumpAndSettle();
      expect(find.text('Preencha este campo.'), findsNWidgets(2));
      expect(find.text('Resultados · 0'), findsOneWidget);

      await tester.enterText(find.byKey(const Key('peso')), '70');
      await tester.enterText(find.byKey(const Key('altura')), '0');
      await tester.ensureVisible(botao);
      await tester.tap(botao);
      await tester.pumpAndSettle();
      expect(find.text('Use um número maior que zero.'), findsOneWidget);
      expect(find.text('Resultados · 0'), findsOneWidget);

      await tester.enterText(find.byKey(const Key('altura')), '1,70');
      await tester.ensureVisible(botao);
      await tester.tap(botao);
      await tester.pumpAndSettle();
      expect(
        tester.widget<Text>(find.byKey(const Key('ultimo-imc'))).data,
        '24,22',
      );
      expect(
        tester.widget<Text>(find.byKey(const Key('ultima-classificacao'))).data,
        'kg/m² · Peso normal',
      );
      expect(find.byKey(const Key('registro-1')), findsOneWidget);

      await tester.enterText(find.byKey(const Key('peso')), '80');
      await tester.enterText(find.byKey(const Key('altura')), '1.80');
      await tester.ensureVisible(botao);
      await tester.tap(botao);
      await tester.pumpAndSettle();
      expect(find.text('Resultados · 2'), findsOneWidget);
      expect(find.byKey(const Key('registro-1')), findsOneWidget);
      expect(find.byKey(const Key('registro-2')), findsOneWidget);
      expect(
        tester.widget<Text>(find.byKey(const Key('ultimo-imc'))).data,
        '24,69',
      );
    },
  );

  testWidgets('funciona em tela estreita com texto ampliado', (tester) async {
    tester.view.physicalSize = const Size(320, 720);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(const ImcApp());
    await tester.enterText(find.byKey(const Key('peso')), '70');
    await tester.enterText(find.byKey(const Key('altura')), '1,70');
    await tester.ensureVisible(find.byKey(const Key('calcular')));
    await tester.tap(find.byKey(const Key('calcular')));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byKey(const Key('registro-1')), findsOneWidget);
  });
}
