import 'package:flutter/material.dart';
import 'package:lista_compra/pages/screen_home.dart';
import 'package:provider/provider.dart';
import 'package:lista_compra/viewmodel/listas_view_model.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) {
        final viewModel = ListasViewModel();
        viewModel.carregarListas();
        return viewModel;
      },
      child: const MeuAplicativo(),
    ),
  );
}

class MeuAplicativo extends StatelessWidget {
  const MeuAplicativo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LISTO',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF0DA4A1), // sua cor principal
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF0DA4A1),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,

      home: HomeScreen(),
    );
  }
}
