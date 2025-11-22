@extends('layouts.app')

@section('content')
<h1>Crear Examen</h1>
<form action="{{ route('examenes.store') }}" method="POST">
    @csrf
    <!-- Agrega los campos necesarios según tu tabla -->
    <button type="submit">Guardar</button>
</form>
@endsection
