import { Component, Input, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { 
  IonCard, IonCardHeader, IonCardTitle, IonCardSubtitle,
  IonItem, IonAvatar, IonLabel,
} from '@ionic/angular/standalone';
import { BackendService } from '@app/core/servicios/backend.service';

@Component({
  selector: 'app-cabeza-perfil',
  templateUrl: './cabeza-perfil.component.html',
  styleUrls: ['./cabeza-perfil.component.scss'],
  standalone: true,
  imports: [
    CommonModule,
    IonCard, IonCardHeader, IonCardTitle, IonCardSubtitle,
    IonItem, IonAvatar, IonLabel,
  ]
})

export class CabezaPerfilComponent implements OnInit {
  @Input() pacienteId!: number;
  
  nombre: string = 'Cargando...';
  t_sangre: string = 'Cargando...';
  n_emergencia: string = 'Cargando...';
  avatarUrl: string = 'https://ionicframework.com/docs/img/demos/avatar.svg';

  isLoading: boolean = true;

  constructor(private backendService: BackendService) {}

  ngOnInit() {
    this.cargarDatosPaciente();
  }

  cargarDatosPaciente() {
    const pacienteGuardado = localStorage.getItem('pacienteActual');
    
    if (pacienteGuardado) {
      const paciente = JSON.parse(pacienteGuardado);
      this.actualizarDatosDesdePaciente(paciente);
    } else if (this.pacienteId) {
      this.cargarPacientePorId(this.pacienteId);
    } else {
      this.nombre = 'Paciente no identificado';
      this.t_sangre = 'No disponible';
      this.n_emergencia = 'No disponible';
      this.isLoading = false;
    }
  }

  private actualizarDatosDesdePaciente(paciente: any) {
    this.nombre = `${paciente.nombre}`;
    this.n_emergencia = this.formatearTelefono(paciente.telefono_emergencia) || 'No registrado';

    if (paciente.tipo_sangre_id) {
      this.cargarTipoSangre(paciente.tipo_sangre_id);
    } else {
      this.t_sangre = 'No registrado';
      this.isLoading = false;
    }
  }

  private formatearTelefono(telefono: string): string {
    if (!telefono) return '';
    const telefonoLimpio = telefono.replace(/\D/g, '');
    
    if (telefonoLimpio.startsWith('569') && telefonoLimpio.length === 11) {
      return `+56 9 ${telefonoLimpio.slice(3, 7)} ${telefonoLimpio.slice(7)}`;
    }
    
    if (telefonoLimpio.startsWith('56') && telefonoLimpio.length === 10) {
      return `+56 9 ${telefonoLimpio.slice(2, 6)} ${telefonoLimpio.slice(6)}`;
    }
    
    if (telefonoLimpio.startsWith('9') && telefonoLimpio.length === 9) {
      return `+56 9 ${telefonoLimpio.slice(1, 5)} ${telefonoLimpio.slice(5)}`;
    }

    if (telefonoLimpio.length === 8) {
      return `+56 9 ${telefonoLimpio.slice(0, 4)} ${telefonoLimpio.slice(4)}`;
    }
    
    return telefono;
  }

  private cargarPacientePorId(pacienteId: number) {
    this.backendService.obtenerPerfilPaciente(pacienteId).subscribe({
      next: (paciente) => {
        this.actualizarDatosDesdePaciente(paciente);
      },
      error: (error) => {
        console.error('Error cargando paciente:', error);
        this.nombre = 'Error al cargar';
        this.isLoading = false;
      }
    });
  }

  private cargarTipoSangre(tipoSangreId: number) {
    this.backendService.getTipoSangre(tipoSangreId).subscribe({
      next: (tipoSangre) => {
        this.t_sangre = tipoSangre.tiposangre;
        this.isLoading = false;
      },
      error: (error) => {
        console.error('Error cargando tipo de sangre:', error);
        this.t_sangre = 'No disponible';
        this.isLoading = false;
      }
    });
  }

  recargarDatos() {
    this.isLoading = true;
    this.cargarDatosPaciente();
  }
}