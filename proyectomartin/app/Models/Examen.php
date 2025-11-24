<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Examen extends Model
{
    use HasFactory;

    protected $table = 'examen';
    
    public $timestamps = false;

    protected $fillable = [
        'fecha',
        'estadoexamen',
        'comentariosexamen',
        'rutapdf',
        'ficha_medica_id',
        'tipo_examen_id',
        'sucursal_id',
        'paciente_id',
    ];

    public function paciente()
    {
        return $this->belongsTo(Paciente::class);
    }

    public function tipoExamen()
    {
        return $this->belongsTo(TipoExamen::class, 'tipo_examen_id');
    }

    public function sucursal()
    {
        return $this->belongsTo(Sucursal::class);
    }

    public function fichaMedica()
    {
        return $this->belongsTo(FichaMedica::class);
    }
}