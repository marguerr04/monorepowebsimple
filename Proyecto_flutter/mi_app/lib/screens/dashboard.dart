import 'package:flutter/material.dart';
import '../widgets/layout/admin_sidebar.dart';
import '../widgets/dashboard/analyte_line_chart.dart';
import '../widgets/dashboard/results_bar_chart.dart'; 
import 'dart:async';
import '../models/analito_point.model.dart';
import '../models/examen_stats.model.dart';
import '../services/analitos_services.dart';
import '../services/examenes_services.dart';
import '../services/dashboard_service.dart';
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
  final DashboardService _dashboardService = DashboardService();
  
  List<AnalitoPoint> _historial = [];
  List<ExamenStats> _estadisticas = [];
  Map<String, dynamic> _dashboardStats = {
    'totalPacientes': 0,
    'consultasHoy': 0,
    'examenesRecientes': 0,
    'alertasCriticas': 0,
  };
  String? _lastFetchTime;
  Timer? _pollingTimer;
  bool _isLoading = true;

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

    print("2. 📈 Cargando estadísticas de exámenes...");
    final statsData = await _examenesService.fetchEstadisticas();
    print("✅ Estadísticas obtenidas del servicio");
    
    print("3. 📊 Cargando estadísticas del dashboard...");
    final dashboardData = await _dashboardService.getEstadisticasDashboard();
    print("✅ Estadísticas dashboard: $dashboardData");

    setState(() {
      _historial = historialData;
      _estadisticas = statsData;
      _dashboardStats = dashboardData;
      _isLoading = false;
      if (historialData.isNotEmpty) {
        _lastFetchTime = historialData.last.fecha.toIso8601String();
      }
    });
    
    print("4. 🎉 Todos los datos cargados exitosamente!");
    
  } catch (e) {
    print("❌ Error carga inicial: $e");
    print("📌 Tipo de error: ${e.runtimeType}");
    setState(() {
      _isLoading = false;
    });
  }
}

  Future<void> _loadDataWithPolling() async {
    try {
      print("🔄 Polling: Actualizando datos del dashboard...");
      
      // CARGA CON POLLING - datos actualizados
      final nuevosAnalitos = await _analitosService.fetchHistorial(
        1, "Glucosa", 
        lastFetchTime: _lastFetchTime
      );
      
      final nuevasStats = await _examenesService.fetchEstadisticas(
        lastFetchTime: _lastFetchTime
      );
      
      // Actualizar estadísticas del dashboard
      final dashboardData = await _dashboardService.getEstadisticasDashboard();

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
        
        // Actualizar estadísticas del dashboard
        _dashboardStats = dashboardData;
        
        print("✅ Dashboard actualizado: ${_dashboardStats['totalPacientes']} pacientes");
      });
    } catch (e) {
      print("⚠️ Error en polling: $e");
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
          // Sidebar
          AdminSidebar(
            selectedIndex: 0,
            onItemSelected: (index) {
              switch (index) {
                case 0: // Dashboard (estamos aquí)
                  break;
                case 1: // Panel de Control
                  Navigator.pushReplacementNamed(context, '/panel-control');
                  break;
                case 2: // Cerrar sesión
                  Navigator.pushReplacementNamed(context, '/login');
                  break;
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
                  _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tarjeta 1
                        MetricSummaryCard(
                          title: "Total de pacientes registrados",
                          value: "${_dashboardStats['totalPacientes']}",
                          changePercentage: "",
                          changeColor: Colors.green,
                        ),
                        
                        const SizedBox(width: 24), // Espacio entre tarjetas

                        // Tarjeta 2
                        MetricSummaryCard(
                          title: "Consultas de hoy",
                          value: "${_dashboardStats['consultasHoy']}",
                          changePercentage: "",
                          changeColor: Colors.green,
                        ),
                        
                        const SizedBox(width: 24), // Espacio entre tarjetas

                        // Tarjeta 3
                        MetricSummaryCard(
                          title: "Pacientes con alertas críticas",
                          value: "${_dashboardStats['alertasCriticas']}",
                          changePercentage: "",
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