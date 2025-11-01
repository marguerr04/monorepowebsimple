import 'package:flutter/material.dart';

const Color cyanClaro = Color(0xFF63FFAC);
const Color cyanOscuro = Color(0xFF30CBA1);
const Color negro = Color(0xFF000000);
const Color blanco = Colors.white;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blanco,
      appBar: AppBar(
        backgroundColor: cyanOscuro,
        title: Text(
          'VitaLog - Home',
          style: TextStyle(color: blanco),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ícono de bienvenida
              Icon(
                Icons.check_circle_outline,
                size: 100,
                color: cyanClaro,
              ),
              
              SizedBox(height: 30),
              
              // Título
              Text(
                '¡Bienvenido a VitaLog!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: negro,
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: 15),
              
              // Subtítulo
              Text(
                'Has iniciado sesión exitosamente',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: 50),
              
              // Botón para cerrar sesión
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: cyanClaro,
                  minimumSize: Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  // Volver al login
                  Navigator.pop(context);
                },
                icon: Icon(Icons.logout, color: negro),
                label: Text(
                  'Cerrar Sesión',
                  style: TextStyle(
                    color: negro,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}