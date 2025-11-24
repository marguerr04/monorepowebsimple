<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Paciente extends Model
{
    use HasFactory;

    protected $table = 'paciente';

    protected $fillable = [
        'rut',
        'dv',
        'nombre',
        'sexo',
        'fechanac',
        'telefono',
        'correo',
        'direccion',
        'tipo_sangre_id',
        'clave',
        'telefono_emergencia',
        'centro_medico_id',
        'activo'
    ];

    protected $casts = [
        'fechanac' => 'date',
        'activo' => 'boolean',
    ];

    // Relaciones
    // public function tipoSangre()
    // {
    //     return $this->belongsTo(TipoSangre::class, 'tipo_sangre_id');
    // }

    // public function fichaMedica()
    // {
    //     return $this->hasOne(FichaMedica::class, 'paciente_id');
    // }

    // public function examenes()
    // {
    //     return $this->hasMany(Examen::class, 'paciente_id');
    // }
}
