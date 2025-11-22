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
    Schema::create('examenes', function (Blueprint $table) {
        $table->id();
        $table->date('fecha');
        $table->string('centro_medico');
        $table->string('tipo_examen');
        $table->text('resultado')->nullable();
        $table->unsignedBigInteger('paciente_id');
        $table->timestamps();
        $table->foreign('paciente_id')->references('id')->on('pacientes');
    });
}
    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('examens');
    }
};
