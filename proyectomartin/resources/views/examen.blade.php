@extends('layouts.app')
@section('content')
<h1 class="mb-4">Exámenes</h1>
<a href="{{ route('examenes.create') }}" class="btn btn-primary mb-3">Nuevo Examen</a>
<div class="card">
  <div class="card-body">
    <table class="table">
      <thead>
        <tr>
          <th>ID</th>
          <th>Fecha</th>
          <th>Centro Médico</th>
          <th>Tipo</th>
          <th>Paciente</th>
          <th>Acciones</th>
        </tr>
      </thead>
      <tbody>
        @foreach($examenes as $examen)
          <tr>
            <td>{{ $examen->id }}</td>
            <td>{{ $examen->fecha }}</td>
            <td>{{ $examen->centro_medico }}</td>
            <td>{{ $examen->tipo_examen }}</td>
            <td>{{ $examen->paciente->nombre ?? 'Sin paciente' }}</td>
            <td>
              <a href="{{ route('examenes.show', $examen) }}" class="btn btn-info btn-sm">👁️</a>
              <a href="{{ route('examenes.edit', $examen) }}" class="btn btn-warning btn-sm">✏️</a>
              <form method="POST" action="{{ route('examenes.destroy', $examen) }}" style="display:inline;">
                @csrf @method('DELETE')
                <button type="submit" class="btn btn-danger btn-sm">🗑️</button>
              </form>
            </td>
          </tr>
        @endforeach
      </tbody>
    </table>
    <div class="mt-3">
      {{ $examenes->links() }}
    </div>
  </div>
</div>
@endsection