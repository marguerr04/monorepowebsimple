<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>VitaLog - Dashboard</title>
    <link rel="stylesheet" href="{{ asset('css/dashboard.css') }}">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="d-flex">
    <!-- Sidebar -->
    <div class="sidebar p-3">
        <h4 class="text-white mb-4">VitaLog</h4>
        <a href="#" class="nav-link text-white">📊 Dashboard</a>
        <a href="#" class="nav-link text-white">🧑‍⚕️ Pacientes</a>
        <a href="#" class="nav-link text-white">📅 Consultas</a>
        <a href="#" class="nav-link text-white">⚙️ Configuración</a>
        <a href="{{ route('examenes.index') }}" class="nav-link text-white">📝 Exámenes</a>
        <button class="btn btn-danger w-100 mt-auto">Cerrar sesión</button>
    </div>

    <!-- Contenido principal -->
    <div class="main flex-grow-1 p-4">
        <h3 class="mb-4">Panel de Control</h3>
        <div class="row g-3">
            <div class="col-md-4">
                <div class="card p-3 shadow-sm">
                    <h6>Total de pacientes registrados</h6>
                    <h4>7495</h4>
                    <small class="text-success">+50%</small>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card p-3 shadow-sm">
                    <h6>Promedio de consultas diarias</h6>
                    <h4>45</h4>
                    <small class="text-success">+2.3%</small>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card p-3 shadow-sm">
                    <h6>Pacientes con alertas críticas</h6>
                    <h4>50</h4>
                    <small class="text-danger">-2.3%</small>
                </div>
            </div>
        </div>

        <div class="row mt-4 g-4">
            <div class="col-md-6">
                <div class="card p-3">
                    <h6>Consultas y Diagnósticos por Tipo</h6>
                    <img src="{{ asset('img/grafico1.png') }}" class="img-fluid rounded">
                </div>
            </div>
            <div class="col-md-6">
                <div class="card p-3">
                    <h6>Consultas y Diagnósticos por Patología</h6>
                    <img src="{{ asset('img/grafico2.png') }}" class="img-fluid rounded">
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
