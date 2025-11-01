<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('pacientes', function (Blueprint $table) {
            $table->id(); // <-- El ID único del paciente 
            
            
            $table->string('nombre_completo');
            $table->string('rut')->unique(); // 'unique()' asegura que no se repita
            $table->date('fecha_nacimiento');
            $table->string('telefono')->nullable(); // 'nullable()' permite que esté vacío
            $table->string('email')->unique()->nullable();
            $table->string('direccion')->nullable();

            
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('pacientes');
    }
};
