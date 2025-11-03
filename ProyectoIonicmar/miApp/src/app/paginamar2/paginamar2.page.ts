import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { IonicModule } from '@ionic/angular';
import { PacienteHeaderComponent } from '../componentes/paciente-header/paciente-header.component';
import { ListaArchivosComponent } from '../componentes/lista-archivos/lista-archivos.component';
import { CabezaPerfilComponent } from '../componentes/cabeza-perfil/cabeza-perfil.component';
import { BackendService } from '@app/core/servicios/backend.service';

@Component({
  selector: 'app-paginamar2',
  templateUrl: './paginamar2.page.html',
  styleUrls: ['./paginamar2.page.scss'],
  standalone: true,
  imports: [CommonModule, RouterModule, IonicModule, PacienteHeaderComponent, ListaArchivosComponent, CabezaPerfilComponent]
})

export class Paginamar2Page implements OnInit {
  pacienteActual: any = null;
  consultas: any[] = [];
  isLoading: boolean = true;

  botonesA = [
  { texto: 'Añadir consulta', ruta: '/nuevaconsulta' },
  { texto: 'Home', ruta: '/home', },
  ];

  warning = "Última consulta: Hace 20 días";

  constructor(private backendService: BackendService) {}

  ngOnInit() {
    this.cargarPacienteActual();
  }

  cargarPacienteActual() {
    const pacienteGuardado = localStorage.getItem('pacienteActual');
    if (pacienteGuardado) {
      this.pacienteActual = JSON.parse(pacienteGuardado);
      console.log('👤 Paciente cargado para consultas:', this.pacienteActual);
      this.cargarConsultasDelPaciente();
    } else {
      this.warning = "No se pudo cargar el paciente";
      this.isLoading = false;
    }
  }

  cargarConsultasDelPaciente() {
    if (this.pacienteActual && this.pacienteActual.id) {
      this.backendService.getConsultasPorPaciente(this.pacienteActual.id).subscribe({
        next: (consultas) => {
          console.log('📋 Consultas cargadas:', consultas);
          this.consultas = this.formatearConsultas(consultas);
          this.actualizarWarning();
          this.isLoading = false;
        },
        error: (error) => {
          console.error('❌ Error cargando consultas:', error);
          this.warning = "Error al cargar las consultas";
          this.isLoading = false;
        }
      });
    } else {
      this.warning = "Paciente no identificado";
      this.isLoading = false;
    }
  }

  formatearConsultas(consultas: any[]): any[] {
    const consultasOrdenadas = [...consultas].sort((a, b) => {
      return new Date(b.fecha).getTime() - new Date(a.fecha).getTime();
    });
    
    const totalConsultas = consultasOrdenadas.length;
    
    return consultasOrdenadas.map((consulta, index) => ({
      id: consulta.id,
      nombre: `Consulta ${totalConsultas - index}`,
      fecha: this.formatearFecha(consulta.fecha),
      diagnostico: consulta.diagnostico || 'Sin diagnóstico',
      medico: consulta.medico || 'No especificado',
      fechaOriginal: consulta.fecha
    }));
  }

  formatearFecha(fecha: string): string {
    if (!fecha) return 'Fecha no disponible';
    
    try {
      const fechaObj = new Date(fecha);
      return fechaObj.toLocaleDateString('es-CL', {
        day: '2-digit',
        month: '2-digit',
        year: 'numeric'
      });
    } catch (error) {
      return fecha;
    }
  }

  actualizarWarning() {
    if (this.consultas.length === 0) {
      this.warning = "No hay consultas registradas";
    } else {
      const ultimaConsulta = this.consultas[0];
      this.warning = `Última consulta: ${ultimaConsulta.fecha}`;
    }
  }  
}
