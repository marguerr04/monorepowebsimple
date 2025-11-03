import 'package:flutter/material.dart';
import '../widgets/layout/admin_sidebar.dart';
import '../widgets/dashboard/analyte_line_chart.dart';
import '../widgets/dashboard/results_bar_chart.dart'; 
import 'dart:async';
import '../models/analito_point.model.dart';
import '../models/examen_stats.model.dart';
import '../services/analitos_services.dart';
import '../services/examenes_services.dart';
import '../widgets/dashboard/metric_summary_card.dart';

// CAMBIO 1: Convertir a StatefulWidget
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

// CAMBIO 2: Crear la clase State
class _DashboardPageState extends State<DashboardPage> {
  // CAMBIO 3: Agregar variables de estado y servicios
  final AnalitosService _analitosService = AnalitosService();
  final ExamenesService _examenesService = ExamenesService();
  
  List<AnalitoPoint> _historial = [];
  List<ExamenStats> _estadisticas = [];
  String? _lastFetchTime;
  Timer? _pollingTimer;

  // CAMBIO 4: Agregar initState para polling
  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _startPolling();
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(Duration(seconds: 15), (timer) {
      _loadDataWithPolling();
    });
  }

  Future<void> _loadInitialData() async {
  try {
    print("1. 📊 Cargando analitos...");
    final historialData = await _analitosService.fetchHistorial(1, "Glucosa");
    print("✅ Analitos cargados: ${historialData.length} elementos");

    print("2. 📈 Cargando estadísticas...");
    final statsData = await _examenesService.fetchEstadisticas();
    print("✅ Estadísticas obtenidas del servicio");
    
    // VERIFICAR MANUALMENTE LOS DATOS CRUDOS
    if (statsData.isNotEmpty) {
      final primerStats = statsData[0];
      print("🔍 Primer elemento stats - Campos:");
      print("   tipoExamen: ${primerStats.tipoExamen} (tipo: ${primerStats.tipoExamen.runtimeType})");
      print("   aprobados: ${primerStats.aprobados} (tipo: ${primerStats.aprobados.runtimeType})");
      print("   reprobados: ${primerStats.reprobados} (tipo: ${primerStats.reprobados.runtimeType})");
      print("   lastUpdated: ${primerStats.lastUpdated} (tipo: ${primerStats.lastUpdated.runtimeType})");
    } else {
      print(" Estadísticas vacías");
    }

    setState(() {
      _historial = historialData;
      _estadisticas = statsData;
      if (historialData.isNotEmpty) {
        _lastFetchTime = historialData.last.fecha.toIso8601String();
      }
    });
    
    print("3. 🎉 Todos los datos cargados exitosamente!");
    
  } catch (e) {
    print("❌ Error carga inicial: $e");
    print("📌 Tipo de error: ${e.runtimeType}");
  }
}

  Future<void> _loadDataWithPolling() async {
    if (_lastFetchTime == null) return;
    
    try {
      // CARGA CON POLLING - solo datos nuevos
      final nuevosAnalitos = await _analitosService.fetchHistorial(
        1, "Glucosa", 
        lastFetchTime: _lastFetchTime
      );
      
      final nuevasStats = await _examenesService.fetchEstadisticas(
        lastFetchTime: _lastFetchTime
      );

      setState(() {
        // Agregar nuevos datos de analitos
        if (nuevosAnalitos.isNotEmpty) {
          _historial.addAll(nuevosAnalitos);
          _lastFetchTime = nuevosAnalitos.last.fecha.toIso8601String();
        }
        
        // Reemplazar estadísticas completas
        if (nuevasStats.isNotEmpty) {
          _estadisticas = nuevasStats;
        }
      });
    } catch (e) {
      print("Error en polling: $e");
    }
  }

  // CAMBIO 5: Agregar dispose para limpiar el timer
  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  // CAMBIO 6: Modificar el build para pasar datos reales
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], 
      body: Row(
        children: [
          // Sidebar (NO CAMBIA)
          AdminSidebar(
            selectedIndex: 0,
            onItemSelected: (index) {
              if (index == 1) {
                Navigator.pushNamed(context, '/fichas');
              } else if (index == 2) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
          
          Expanded(
            flex: 8, 
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dashboard Médico',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),

                  // Carta fila de metricas

                  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tarjeta 1
                        MetricSummaryCard(
                          title: "Total de pacientes registrados",
                          value: "7495", // TODO: Reemplazar con datos reales del servicio
                          changePercentage: "+50%",
                          changeColor: Colors.green,
                        ),
                        
                        const SizedBox(width: 24), // Espacio entre tarjetas

                        // Tarjeta 2
                        MetricSummaryCard(
                          title: "Promedio de consultas diarias",
                          value: "45", // TODO: Reemplazar con datos reales del servicio
                          changePercentage: "+2.3%",
                          changeColor: Colors.green,
                        ),
                        
                        const SizedBox(width: 24), // Espacio entre tarjetas

                        // Tarjeta 3
                        MetricSummaryCard(
                          title: "Pacientes con alertas críticas",
                          value: "50", // TODO: Reemplazar con datos reales del servicio
                          changePercentage: "-2.3%",
                          changeColor: Colors.red,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24), // Espacio extra antes de los gráficos



                  // CAMBIO 7: Pasar datos reales a los gráficos
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < 900) {
                        return Column(
                          children: [
                            AnalyteLineChart(data: _historial), // DATOS REALES
                            SizedBox(height: 24),
                            ResultsBarChart(data: _estadisticas), // DATOS REALES
                          ],
                        );
                      }
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: AnalyteLineChart(data: _historial)), // DATOS REALES
                          SizedBox(width: 24),
                          Expanded(child: ResultsBarChart(data: _estadisticas)), // DATOS REALES
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}