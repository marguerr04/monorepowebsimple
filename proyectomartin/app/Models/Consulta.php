<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Consulta extends Model
{
    use HasFactory;

    protected $table = 'consulta';
    
    public $timestamps = false;

    protected $fillable = [
        'fecha',
        'paciente_id',
        'medico_id',
        'tipo_consult_id',
        'ficha_medica_id',
        'pesopaciente',
        'alturapaciente',
        'motivo_consulta',
    ];

    protected $casts = [
        'fecha' => 'date',
        'pesopaciente' => 'decimal:2',
        'alturapaciente' => 'decimal:2',
    ];

    public function paciente()
    {
        return $this->belongsTo(Paciente::class);
    }

    public function fichaMedica()
    {
        return $this->belongsTo(FichaMedica::class);
    }
}
