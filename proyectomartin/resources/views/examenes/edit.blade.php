@extends('layouts.app')

@section('content')
<h1>Editar Examen</h1>
<form action="{{ route('examenes.update', $examen) }}" method="POST">
    @csrf
    @method('PUT')
    <!-- Agrega los campos necesarios según tu tabla -->
    <button type="submit">Actualizar</button>
</form>
@endsection
