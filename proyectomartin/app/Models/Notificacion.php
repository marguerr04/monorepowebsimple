<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Notificacion extends Model
{
    protected $table = 'notificacion';
    
    public $timestamps = false;
    
    protected $fillable = [
        'tipo',
        'mensaje',
        'datos',
        'leida',
        'fecha_creacion'
    ];
    
    protected $casts = [
        'datos' => 'array',
        'leida' => 'boolean',
        'fecha_creacion' => 'datetime'
    ];
}
