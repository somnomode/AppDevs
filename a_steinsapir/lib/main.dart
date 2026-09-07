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
        backgroundColor: const Color.fromARGB(255, 220, 219, 219),
        //appBar agrega una barra en la parte superior de la pantalla
        appBar: AppBar(
          // naranjo Color.fromARGB(255, 225, 138, 16)
          // azul Color.fromARGB(255, 18, 5, 54)
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          leadingWidth: 160, //eadingWidth define el ancho del espacio que ocupa el leading, si no se define, el ancho será el del icono

          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.close),
                color: const Color.fromARGB(251, 54, 54, 54),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.undo),
                color: const Color.fromARGB(251, 54, 54, 54),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.redo),
                color: const Color.fromARGB(251, 54, 54, 54),
                onPressed: () {},
              ),
            ],
          ),

          //title define el contenid que aparece dentro de la barra.
          //en este caso ponemos Clase 1.
          actions: [
            IconButton(
              icon: const Icon(Icons.more_horiz),
              color: const Color.fromARGB(251, 54, 54, 54),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.view_column),
              color: const Color.fromARGB(251, 54, 54, 54),
              onPressed: () {},
            ),
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Guardar'),
              //iconAlignment: _iconAlignment,
            ),
          ],
        ),

        body: ListView(
          //ListView permite hacer scroll en la pantalla, SingleChildScrollView permite hacer scroll en la pantalla, pero solo si el contenido es más grande que la pantalla
          //child: Column(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              color: const Color.fromARGB(255, 207, 207, 207),

              child: const Center(
                child: Text(
                  'espacio',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
            //PARA HACER EL ESPACIADO ENTRE OBJETOS ES MEJOR SIZEDBOX, para casos especificos se puede usar Edgeinsets marging y padding
            SizedBox(height: 8.0), //SizedBox agrega un espacio entre los contenedores, height es para espacio vertical y width para horizontal
            Container(
              height: 400,
              width: double.infinity,

              margin: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 8.0,
                bottom: 24.0,
              ), //EdgeInsets agrega un margen alrededor del contenedor, all es para todos los lados, only es para un lado específico, symmetric es para lados opuestos, si hay un SizedBox aplicado esto se le suma a ese valor

              color: const Color.fromARGB(255, 228, 184, 247),

              child: const Center(
                child: Text(
                  'container 2',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
            Container(
              height: 200,
              width: double.infinity,
              color: const Color.fromARGB(255, 207, 207, 207),

              child: const Center(
                child: Text(
                  'espacio',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),

            //ListView permite hacer scroll en la pantalla, SingleChildScrollView permite hacer scroll en la pantalla, pero solo si el contenido es más grande que l
            SizedBox(height: 8.0),
            Container(
              height: 50,
              width: double.infinity,
              color: const Color.fromARGB(255, 255, 255, 255),

              child: const Center(
                child: Text(
                  'filtros',
                  style: TextStyle(
                    color: Color.fromARGB(255, 168, 168, 168),
                    fontSize: 24,
                  ),
                ),
              ),
            ),

            SizedBox(height: 8.0),
            Container(
              height: 150,
              width: double.infinity,

              //espacio exterior horizontal
              margin: const EdgeInsets.symmetric(horizontal: 16.0),

              color: const Color.fromARGB(255, 255, 255, 255),

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start, //crossAxisAlignment define la alineación vertical de los elementos dentro del Row, start es para alinear al inicio, center es para centrar y end es para alinear al final
                children: [
                  Expanded(
                    child: Container(
                      height: 150,

                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 200, 178, 238),
                        borderRadius: BorderRadius.circular(16.0), //borderRadius define el radio de las esquinas del contenedor
                      ), //height define la altura del contenedor, si no se define, el contenedor tomará la altura del contenido

                      child: const Center(
                        child: Text(
                          'left',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Container(
                      height: 150,

                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 165, 97, 229),
                        borderRadius: BorderRadius.circular(16.0), //borderRadius define el radio de las esquinas del contenedor
                      ), //height define la altura del contenedor, si no se define, el contenedor tomará la altura del contenido

                      child: const Center(
                        child: Text(
                          'center',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 132, 34, 230),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: const Center(
                        child: Text(
                          'right',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ),
                    ),
                  ),
                ], //row children
              ),
            ),
                SizedBox(height: 8.0),
                Container(
                  height: 50,
                  width: double.infinity,
                  color: const Color.fromARGB(255, 255, 255, 255),

                  child: const Center(
                    child: Text(
                      'presets',
                      style: TextStyle(
                        color: Color.fromARGB(255, 168, 168, 168),
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),

            SizedBox(height: 8.0),
            Container(
              height: 50,
              width: double.infinity,
              color: const Color.fromARGB(255, 255, 255, 255),

              child: const Center(
                child: Text(
                  'estilos',
                  style: TextStyle(
                    color: Color.fromARGB(255, 168, 168, 168),
                    fontSize: 24,
                  ),
                ),
              ),
            ),
          ], //children de ListView
        ),

        //),

        //bottomNavigationBar agrega una barra en la parte inferior de la pantalla
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,

          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          selectedItemColor: const Color.fromARGB(255, 58, 58, 57),
          unselectedItemColor: const Color.fromARGB(255, 86, 86, 86),

          items: const [
            //icono de mensajes
            BottomNavigationBarItem(icon: Icon(Icons.stop), label: ' '),
            BottomNavigationBarItem(
              icon: Icon(Icons.radio_button_checked),
              label: ' ',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.play_arrow), label: ' '),
          ],
        ),
      ),
    );
  }
}
