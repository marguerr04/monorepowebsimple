import 'package:flutter/material.dart';
// Importa tus pantallas
import 'screens/login.dart';
import 'screens/dashboard.dart';
import 'screens/panel_control_screen.dart';
import 'screens/perfil.dart';
import 'screens/test_connection_page.dart';
import 'screens/fichas_screen.dart';
import 'screens/consultas_screen.dart';
import 'screens/examenes_screen.dart';
import 'screens/pacientes_screen.dart';
import 'screens/pokeapi_screen.dart'; // Mantienes esta si aún la usas
// Importa tu paleta de colores
import 'utils/app_colors.dart';

void main() {
  runApp(const ElMedicoApp()); // Asegúrate que ElMedicoApp sea el nombre correcto
}

class ElMedicoApp extends StatelessWidget {
  const ElMedicoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'El Médico Admin', // Título actualizado para reflejar el rol
      theme: ThemeData(
        // Color primario: Usado para botones principales, AppBar, elementos activos.
        primaryColor: AppColors.cyanOscuro,
        // Esquema de colores: Define cómo interactúan los colores
        colorScheme: ColorScheme.light(
          primary: AppColors.cyanOscuro,       // Color principal para elementos interactivos
          secondary: AppColors.cyanClaro,     // Color de acento
          onPrimary: AppColors.blanco,        // Texto sobre color primario (ej. botones)
          onSecondary: AppColors.negro,       // Texto sobre color secundario
          surface: AppColors.blanco,        // Fondo de cards, dialogs, etc.
          onSurface: AppColors.textoOscuro,// Texto sobre el fondo general
          error: AppColors.error,           // Color para errores
          onError: AppColors.blanco,          // Texto sobre color de error
        ),
        // Fondo por defecto de los Scaffold (pantallas)
        scaffoldBackgroundColor: AppColors.fondoClaro,
        // Estilos de texto globales (puedes añadir más)
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: AppColors.textoOscuro, fontSize: 14), // Texto estándar
          titleLarge: TextStyle(color: AppColors.textoOscuro, fontWeight: FontWeight.bold, fontSize: 22), // Títulos grandes
          labelLarge: TextStyle(color: AppColors.blanco, fontWeight: FontWeight.bold), // Texto para botones elevados
        ),
         // Estilo global para ElevatedButton
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.cyanOscuro, // Color primario
            foregroundColor: AppColors.blanco,    // Texto blanco
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0), // Bordes redondeados
            ),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
         // Estilo global para TextButton
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.cyanOscuro, // Color primario
          ),
        ),
        // Estilo global para IconButton
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
             foregroundColor: AppColors.grisOscuro, // Color neutro para iconos
          )
        ),
         // Estilo global para campos de texto y Dropdowns (InputDecoration)
         inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppColors.blanco, // Fondo blanco por defecto
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), // Padding interno
             border: OutlineInputBorder( // Borde por defecto
               borderRadius: BorderRadius.circular(8.0),
               borderSide: BorderSide(color: AppColors.bordeClaro),
             ),
             enabledBorder: OutlineInputBorder( // Borde cuando está habilitado
               borderRadius: BorderRadius.circular(8.0),
               borderSide: BorderSide(color: AppColors.bordeClaro),
             ),
             focusedBorder: OutlineInputBorder( // Borde cuando tiene foco
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: AppColors.cyanOscuro, width: 2.0), // Borde más grueso y color primario
             ),
             hintStyle: const TextStyle(color: AppColors.gris), // Estilo para el placeholder (hint)
             labelStyle: const TextStyle(color: AppColors.grisOscuro), // Estilo para la etiqueta flotante
             prefixIconColor: AppColors.gris, // Color para iconos de prefijo
         ),
         // Estilo para AppBar (barra superior)
         appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.cyanOscuro, // Color primario
            foregroundColor: AppColors.blanco, // Color de texto e iconos
            elevation: 1.0, // Sombra sutil
            titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.blanco),
         ),
         // Estilo para DataTable (tablas)
         dataTableTheme: DataTableThemeData(
            headingRowColor: WidgetStateProperty.all(Colors.grey[100]), // Fondo cabecera
            dataTextStyle: const TextStyle(fontSize: 13, color: AppColors.textoOscuro),
            headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textoOscuro),
            columnSpacing: 20.0,
         ),
         // Estilo para Chips (usados en la tabla de fichas)
         chipTheme: ChipThemeData(
            backgroundColor: AppColors.gris,
            labelStyle: const TextStyle(fontSize: 10, color: AppColors.blanco),
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
         ),
      ),
      // Pantalla inicial de la aplicación
      home: LoginPage(),
      // Definición de las rutas nombradas para la navegación
      routes: {
        '/login': (context) => LoginPage(),
        '/dashboard': (context) => const DashboardPage(),
        '/panel-control': (context) => const PanelControlScreen(),
        '/perfil': (context) => PerfilPage(), // Asumiendo que existe o la crearás
        '/test-connection': (context) => const TestConnectionPage(),
        '/fichas': (context) => const FichasScreen(),
        '/consultas': (context) => const ConsultasScreen(),
        '/pacientes': (context) => const PacientesScreen(),
        '/pokeapi': (context) => const PokeApiScreen(), // Mantienes esta si la usas
        // '/main-layout': (context) => const MainLayoutScreen(), // Si usas el layout contenedor
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/examenes') {
          final fichaId = settings.arguments as int?;
          return MaterialPageRoute(
            builder: (context) => ExamenesScreen(fichaIdInicial: fichaId),
          );
        }
        return null;
      },
    );
  }
}

// Asegúrate de tener creadas las clases LoginPage, DashboardPage, PerfilPage,
// TestConnectionPage, FichasScreen, PokeApiScreen en sus respectivos archivos.
// Asegúrate también de tener el archivo utils/app_colors.dart con las definiciones de color.

