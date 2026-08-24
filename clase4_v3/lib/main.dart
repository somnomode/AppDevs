import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: Scaffold(
        //appBar agrega una barra en la parte superior de la pantalla
        appBar: AppBar(
          // naranjo Color.fromARGB(255, 225, 138, 16)
          // azul Color.fromARGB(255, 18, 5, 54)
          backgroundColor: const Color.fromARGB(255, 18, 5, 54),
          leading: IconButton(
            icon: const Icon(Icons.menu),
            color: Color.fromARGB(255, 225, 138, 16),
            onPressed: () {},
          ),
          //title define el contenid que aparece dentro de la barra.
          //en este caso ponemos Clase 1.
          title: const Text(
            'clase uno',
            style: TextStyle(color: Color.fromARGB(255, 225, 138, 16)),
          ),
          actions: [
            //popup menu button
            PopupMenuButton<String>(
              icon: const Icon(
                Icons.more_vert,
                color: Color.fromARGB(255, 225, 138, 16),
              ),
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem<String>(
                  value: 'perfil',
                  child: Row(
                    children: [
                      Icon(Icons.person),
                      SizedBox(width: 10),
                      Text('Perfil'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'bullshit',
                  child: Row(
                    children: [
                      Icon(Icons.warning),
                      SizedBox(width: 10),
                      Text('Bullshit'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'configuracion',
                  child: Row(
                    children: [
                      Icon(Icons.settings),
                      SizedBox(width: 10),
                      Text('Configuración'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),

        body: Column(

          children: [
            //agregamos un contenedor con un color de fondo y un texto
            Container(
              height: 570.0, //altura de 570 pixeles
              width: double.infinity, //ocupa todo el ancho
              color: const Color.fromARGB(255, 225, 138, 16), //color de fondo
              child: const Text('tamaño card'),
              ),
            Container(
              height: 300.0, //VAMOS A VER ESTO
              width: double.infinity,
              color: const Color.fromARGB(255, 235, 178, 100),
              child: const Text('tamaño card'),
            ),
          ],
        ),

        //bottomNavigationBar agrega una barra en la parte inferior de la pantalla
        bottomNavigationBar: BottomNavigationBar(
          //backgroundColor: const Color.fromARGB(255, 18, 5, 54),
          items: const [
            //icono de mensajes
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: 'Mensajes',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          ],
        ),
      ),
    );
  }
}
