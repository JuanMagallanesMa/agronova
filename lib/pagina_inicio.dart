import 'package:flutter/material.dart';
import 'package:agronova/ventanaHTTP.dart';
import 'package:agronova/pagina_categorias.dart';
import 'package:agronova/pagina_acerca.dart';

class PaginaInicio extends StatefulWidget {
  const PaginaInicio({super.key});

  @override
  State<PaginaInicio> createState() => _PaginaInicioState();
}

class _PaginaInicioState extends State<PaginaInicio> {
  int _paginaSeleccionada = 0;

  final List<Widget> _paginas = [
    const PaginaCategorias(),
    const VentanaHTTP(),
    const PaginaAcercaDe(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _paginaSeleccionada = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _paginaSeleccionada == 0
              ? 'Categorías'
              : _paginaSeleccionada == 1
              ? 'Noticias'
              : 'Acerca de',
        ),
        backgroundColor: Colors.green,
      ),
      body: _paginas[_paginaSeleccionada],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _paginaSeleccionada,
        selectedItemColor: Colors.green,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categorías',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Noticias'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Acerca de'),
        ],
      ),
    );
  }
}
