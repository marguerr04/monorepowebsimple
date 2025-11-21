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
    Schema::create('ficha_medicas', function (Blueprint $table) {
        $table->id();
        $table->unsignedBigInteger('paciente_id');
        $table->text('observaciones')->nullable();
        $table->timestamps();

        $table->foreign('paciente_id')->references('id')->on('pacientes')->onDelete('cascade');
    });
}

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('ficha_medicas');
    }
};
