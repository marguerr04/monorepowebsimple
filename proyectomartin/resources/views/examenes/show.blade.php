@extends('layouts.app')

@section('content')
<h1>Detalle Examen</h1>
<p>ID: {{ $examen->id }}</p>
<p>Paciente: {{ $examen->paciente->nombre ?? '' }}</p>
<p>Tipo Examen: {{ $examen->tipoExamen->nombre ?? '' }}</p>
<p>Sucursal: {{ $examen->sucursal->nombre ?? '' }}</p>
<!-- Agrega más campos según tu tabla -->
<a href="{{ route('examenes.index') }}">Volver</a>
@endsection
