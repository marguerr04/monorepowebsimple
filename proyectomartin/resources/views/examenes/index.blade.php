@extends('layouts.app')

@section('content')
<h1>Lista de Exámenes</h1>
<a href="{{ route('examenes.create') }}">Nuevo Examen</a>
<table>
    <thead>
        <tr>
            <th>ID</th>
            <th>Paciente</th>
            <th>Tipo Examen</th>
            <th>Sucursal</th>
            <th>Acciones</th>
        </tr>
    </thead>
    <tbody>
        @foreach($examenes as $examen)
        <tr>
            <td>{{ $examen->id }}</td>
            <td>{{ $examen->paciente->nombre ?? '' }}</td>
            <td>{{ $examen->tipoExamen->nombre ?? '' }}</td>
            <td>{{ $examen->sucursal->nombre ?? '' }}</td>
            <td>
                <a href="{{ route('examenes.show', $examen) }}">Ver</a>
                <a href="{{ route('examenes.edit', $examen) }}">Editar</a>
                <form action="{{ route('examenes.destroy', $examen) }}" method="POST" style="display:inline;">
                    @csrf
                    @method('DELETE')
                    <button type="submit">Eliminar</button>
                </form>
            </td>
        </tr>
        @endforeach
    </tbody>
</table>
@endsection
