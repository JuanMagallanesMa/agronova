import 'package:flutter/material.dart';
import 'package:agronova/ventanaHTTP.dart';
import 'package:agronova/pagina_categorias.dart';

class PaginaInicio extends StatefulWidget {
  const PaginaInicio({super.key});

  @override
  State<PaginaInicio> createState() => _PaginaInicioState();
}

class _PaginaInicioState extends State<PaginaInicio> {
  int _paginaSeleccionada = 0;

  // Lista de widgets que se mostrará según la pestaña activa
  final List<Widget> _paginas = [const PaginaCategorias(), const VentanaHTTP()];

  void _onItemTapped(int index) {
    setState(() {
      _paginaSeleccionada = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _paginaSeleccionada == 0
          ? AppBar(
              title: const Text('Bienvenido'),
              backgroundColor: Colors.green,
            )
          : null,
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
        ],
      ),
    );
  }
}
