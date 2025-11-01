import 'package:flutter/material.dart';




class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Perfil del Médico')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Nombre: Santiago Page', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Especialidad: Cardiología'),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Volver al Dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}
