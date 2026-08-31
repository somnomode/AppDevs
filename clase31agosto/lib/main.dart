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
            style: TextStyle(
              color: Color.fromARGB(255, 225, 138, 16),
              ),
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

        body: ListView(
          //ListView permite hacer scroll en la pantalla, SingleChildScrollView permite hacer scroll en la pantalla, pero solo si el contenido es más grande que la pantalla
          //child: Column(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              color: const Color.fromARGB(255, 58, 11, 184),

              child: const Center(
                child: Text(
                  'container 1',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24
                  ),
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

              color: const Color.fromARGB(255, 252, 208, 31),

              child: const Center(
                child: Text(
                  'container 2',
                  style: TextStyle(
                    color: Colors.white, 
                    fontSize: 24
                    ),
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Container(
              height: 600,
              width: double.infinity,

              //espacion EXTERIOR del contenedor
              margin: const EdgeInsets.symmetric(horizontal: 16.0),

              //espacion INTERIOR del contenedor
              padding: const EdgeInsets.all(40.0), //EdgeInsets agrega un padding dentro del contenedor, all es para todos los lados, only es para un lado específico, symmetric es para lados opuestos

              color: const Color.fromARGB(255, 40, 211, 224),

              child: Container(
                color: const Color.fromARGB(255, 168, 143, 235),

                child: const Text(
                  'container 3',
                  style: TextStyle(
                    color: Colors.white, 
                    fontSize: 24
                    ),
                ),
              ),
            ),

            SizedBox(height: 8.0),
            Container(
              height: 200,
              width: double.infinity,

              //espacio exterior horizontal
              margin: const EdgeInsets.symmetric(horizontal: 16.0),

              color: const Color.fromARGB(255, 252, 60, 31),

              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      color: const Color.fromARGB(255, 218, 50, 218),

                      child: const Center(
                        child: Text(
                          'left',
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: 24
                            ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Container(
                      color: const Color.fromARGB(255, 42, 219, 74),

                      child: const Center(
                        child: Text(
                          'right',
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: 24,
                            ),
                        ),
                      ),
                    ),
                  ),
                ], //row children
              ),
            ),
            SizedBox(height: 8.0),
            Container(
              height: 100,
              width: double.infinity,

              //espacio exterior horizontal
              margin: const EdgeInsets.symmetric(
                horizontal: 16.0,
                ),

              color: const Color.fromARGB(255, 252, 83, 31),

              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      color: const Color.fromARGB(255, 200, 178, 238),

                      child: const Center(
                        child: Text(
                          'left',
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: 24
                            ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Container(
                      color: const Color.fromARGB(255, 165, 97, 229),

                      child: const Center(
                        child: Text(
                          'center',
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: 24,
                            ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Container(
                      color: const Color.fromARGB(255, 132, 34, 230),

                      child: const Center(
                        child: Text(
                          'right',
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: 24,
                            ),
                        ),
                      ),
                    ),
                  ),
                ], //row children
              ),
            ),
            SizedBox(height: 8.0),
            Container(
              height: 300,
              width: double.infinity,

              //espacio exterior horizontal
              margin: const EdgeInsets.symmetric(
                horizontal: 16.0,
                ),

              color: const Color.fromARGB(255, 255, 255, 255),

              child: Row(

                  crossAxisAlignment: CrossAxisAlignment.start, //crossAxisAlignment define la alineación vertical de los elementos dentro del Row, start es para alinear al inicio, center es para centrar y end es para alinear al final
                children: [
                  Expanded(
                    child: Container(

                      height: 100,
                      
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 200, 178, 238),
                        borderRadius: BorderRadius.circular(16.0), //borderRadius define el radio de las esquinas del contenedor
                       ), //height define la altura del contenedor, si no se define, el contenedor tomará la altura del contenido
                      

                      child: const Center(
                        child: Text(
                          'left',
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: 24
                            ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Container(
                      color: const Color.fromARGB(255, 165, 97, 229),

                      child: const Center(
                        child: Text(
                          'center',
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: 24,
                            ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Container(
                      color: const Color.fromARGB(255, 132, 34, 230),

                      child: const Center(
                        child: Text(
                          'right',
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: 24,
                            ),
                        ),
                      ),
                    ),
                  ),
                ], //row children
              ),
            ),

          ],//children de ListView
        ),

        //),

        //bottomNavigationBar agrega una barra en la parte inferior de la pantalla
        bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,

          backgroundColor: const Color.fromARGB(255, 18, 5, 54),
          selectedItemColor: const Color.fromARGB(255, 225, 138, 16),
          unselectedItemColor: Colors.white,

          items: const [
            //icono de mensajes
            BottomNavigationBarItem(
              icon: Icon(Icons.home), 
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: 'Mensajes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Buscar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
          ],
        ),
      ),
    );
  }
}
