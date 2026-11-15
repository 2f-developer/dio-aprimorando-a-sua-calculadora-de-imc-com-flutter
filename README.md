# Caderno de IMC

App Flutter para calcular o IMC e manter uma lista dos cálculos feitos. É a segunda parte do desafio de IMC da formação Flutter Specialist da DIO ("Aprimorando a sua Calculadora de IMC com Flutter"): a primeira parte rodava no terminal; aqui o cálculo ganha interface.

Você digita peso e altura, toca em calcular e o resultado aparece em destaque, já com a faixa da OMS (peso normal, sobrepeso etc.). Cada cálculo entra no topo de uma lista, numerado, para dar para comparar medições. A lista vive só enquanto o app está aberto; a persistência fica para o desafio seguinte.

Alguns cuidados que tomei:

- os campos aceitam vírgula ou ponto e recusam vazio, zero, negativo e texto, com a mensagem embaixo do campo;
- do campo de peso o teclado pula para a altura, e o "concluir" da altura já calcula;
- em telas largas os dois campos ficam lado a lado; em telas estreitas, um embaixo do outro.

## Rodando

```bash
flutter pub get
flutter run
```

## Testes

```bash
flutter test
```

Há testes do modelo (`IMC` e as faixas da OMS) e testes de widget que preenchem o formulário, conferem as mensagens de erro, o valor e a classificação exibidos e o crescimento da lista, inclusive numa tela estreita.

## Código

- `lib/imc.dart`: a classe `IMC`, que valida peso e altura e expõe o valor e a classificação;
- `lib/classificacao.dart`: as faixas de IMC da OMS para adultos;
- `lib/main.dart`: a tela, com o formulário e a lista.
