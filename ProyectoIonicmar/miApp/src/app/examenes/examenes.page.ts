import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { IonicModule } from '@ionic/angular';
import { FormsModule } from '@angular/forms';
import { PacienteHeaderComponent } from '../componentes/paciente-header/paciente-header.component';
import { CabezaPerfilComponent } from '../componentes/cabeza-perfil/cabeza-perfil.component';
import { ListaArchivosComponent } from '@app/componentes/lista-archivos/lista-archivos.component';
import { BackendService } from '@app/core/servicios/backend.service';

@Component({
  selector: 'app-examenes',
  templateUrl: './examenes.page.html',
  styleUrls: ['./examenes.page.scss'],
  standalone: true,
  imports: [CommonModule, RouterModule, IonicModule, FormsModule, PacienteHeaderComponent, CabezaPerfilComponent,
    ListaArchivosComponent]
})
export class ExamenesPage implements OnInit {
  pacienteActual: any = null;
  examenes: any[] = [];
  isLoading: boolean = true;

  constructor(private backendService: BackendService) {}

  ngOnInit() {
    this.cargarPacienteActual();
  }

  botonesA = [
  { texto: 'Añadir examen', ruta: '/nuevoexamen' },
  { texto: 'Home', ruta: '/home', },
  ];

  warning = "Cargando exámenes...";

  cargarPacienteActual() {
    const pacienteGuardado = localStorage.getItem('pacienteActual');
    if (pacienteGuardado) {
      this.pacienteActual = JSON.parse(pacienteGuardado);
      console.log('👤 Paciente cargado para exámenes:', this.pacienteActual);
      this.cargarExamenesDelPaciente();
    } else {
      this.warning = "No se pudo cargar el paciente";
      this.isLoading = false;
    }
  }

  cargarExamenesDelPaciente() {
    if (this.pacienteActual && this.pacienteActual.id) {
      this.backendService.getExamenesPorPaciente(this.pacienteActual.id).subscribe({
        next: (examenes) => {
          console.log('🔬 Exámenes cargados:', examenes);
          this.examenes = this.formatearExamenes(examenes);
          this.actualizarWarning();
          this.isLoading = false;
        },
        error: (error) => {
          console.error('❌ Error cargando exámenes:', error);
          this.warning = "Error al cargar los exámenes";
          this.isLoading = false;
        }
      });
    } else {
      this.warning = "Paciente no identificado";
      this.isLoading = false;
    }
  }

  formatearExamenes(examenes: any[]): any[] {
    const examenesOrdenados = [...examenes].sort((a, b) => {
      return new Date(b.fecha).getTime() - new Date(a.fecha).getTime();
    });

    const totalExamenes = examenesOrdenados.length;

    return examenesOrdenados.map((examen, index) => ({
      id: examen.id,
      nombre: `Examen ${totalExamenes - index}`,
      fecha: this.formatearFecha(examen.fecha),
      tipo: examen.tipo || 'No especificado',
      resultado: examen.resultado || 'Pendiente',
      laboratorio: examen.laboratorio || 'No especificado',
      fechaOriginal: examen.fecha
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
    if (this.examenes.length === 0) {
      this.warning = "No hay exámenes registrados";
    } else {
      const examenesConFecha = [...this.examenes].filter(e => e.fechaOriginal);
      if (examenesConFecha.length > 0) {
        const masReciente = examenesConFecha.reduce((masReciente, actual) => {
          return new Date(actual.fechaOriginal) > new Date(masReciente.fechaOriginal) 
            ? actual 
            : masReciente;
        });
        
        const diasDesdeUltimo = this.calcularDiasDesde(masReciente.fechaOriginal);
        
        if (diasDesdeUltimo === 0) {
          this.warning = `Último examen: Hoy`;
        } else if (diasDesdeUltimo === 1) {
          this.warning = `Último examen: Ayer`;
        } else if (diasDesdeUltimo < 30) {
          this.warning = `Último examen: Hace ${diasDesdeUltimo} días`;
        } else {
          const meses = Math.floor(diasDesdeUltimo / 30);
          this.warning = `Último examen: Hace ${meses} ${meses === 1 ? 'mes' : 'meses'}`;
        }
      } else {
        this.warning = `Total de exámenes: ${this.examenes.length}`;
      }
    }
  }

  calcularDiasDesde(fecha: string): number {
    const fechaExamen = new Date(fecha);
    const hoy = new Date();
    const diferencia = hoy.getTime() - fechaExamen.getTime();
    return Math.floor(diferencia / (1000 * 60 * 60 * 24));
  }
}
