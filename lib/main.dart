import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: SizedBox.expand(
        child: FilledButton(
          onPressed: () async {
            final response = await Dio().get(
              'https://localhost:44300/api/v2/Produtos/ObterFotosProdutos',
              options: Options(responseType: ResponseType.stream),
            );

            final String? numProdutos = response.headers.value("Num-Produtos");
            int numProdutosInt = int.parse(numProdutos!);
            final Stream<List<int>> stream = response.data.stream;

            int i = 0;
            stream
                .map((event) => event.toList())
                .transform(const Utf8Decoder())
                .transform(const LineSplitter())
                .map((event) => jsonDecode(event))
                .listen((event) {
              print(++i / numProdutosInt * 100);
            }, onDone: () {
              print("Fim");
            });
          },
          child: const Text('Button'),
        ),
      ),
    );
  }
}
