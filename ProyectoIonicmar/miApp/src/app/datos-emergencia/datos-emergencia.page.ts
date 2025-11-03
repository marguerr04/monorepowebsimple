import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule } from '@angular/router';
import { PacienteHeaderComponent } from '../componentes/paciente-header/paciente-header.component';
import { CabezaPerfilComponent } from '../componentes/cabeza-perfil/cabeza-perfil.component';
import {IonHeader, IonToolbar, IonTitle, IonContent, IonCard, IonCardHeader, IonCardContent, IonButton,
  IonList, IonItem, IonLabel, IonBreadcrumbs, IonBreadcrumb, IonButtons, IonMenuButton,} from '@ionic/angular/standalone';
import { PacienteService, Alergia, Diagnostico } from '@app/services/paciente.service';

@Component({
  selector: 'app-datos-emergencia',
  templateUrl: './datos-emergencia.page.html',
  styleUrls: ['./datos-emergencia.page.scss'],
  standalone: true,
  imports: [IonContent, IonHeader, IonTitle, IonList, IonToolbar, CommonModule, RouterModule,
    IonCard, IonCardHeader, IonCardContent, IonButton, IonItem, IonLabel, IonBreadcrumbs, IonBreadcrumb, IonButtons, IonMenuButton, 
    PacienteHeaderComponent, FormsModule, CabezaPerfilComponent]
})
export class DatosEmergenciaPage implements OnInit {
  mostrarAlergias: boolean = false;
  mostrarCondiciones: boolean = false;
  mostrarSangre: boolean = false;

  patientName = ' ';
  patientBlood = ' ';
  patientNemergency = ' ';

  pacienteId: number | null = null;
  
  alergias: Alergia[] = [];
  diagnosticos: Diagnostico[] = [];
  tipoSangre: string = '';
  
  isLoadingAlergias: boolean = true;
  isLoadingDiagnosticos: boolean = true;
  isLoadingSangre: boolean = true;
  
  errorAlergias: string = '';
  errorDiagnosticos: string = '';
  errorSangre: string = '';

  constructor(private pacienteService: PacienteService) { }

  ngOnInit() {
    this.obtenerPacienteLogueado();
    this.cargarAlergias();
    this.cargarDiagnosticos();
    this.cargarTipoSangre();
  }

  ionViewWillEnter() {
    console.log('🔄 ionViewWillEnter - Actualizando datos del paciente');
    this.obtenerPacienteLogueado();
  }

  obtenerPacienteLogueado() {
    const pacienteGuardado = localStorage.getItem('pacienteActual');
    
    if (pacienteGuardado) {
      try {
        const paciente = JSON.parse(pacienteGuardado);

        this.pacienteId = paciente.id;
        
        console.log('✅ Paciente logueado ID:', this.pacienteId);
        console.log('✅ Datos del paciente:', paciente);
        
        this.patientName = `${paciente.nombre} ${paciente.apellido} | id: ${paciente.id}`;
        this.patientBlood = paciente.tipo_sangre || 'No registrado';
        this.patientNemergency = paciente.telefono_emergencia || 'No registrado';
        
        this.cargarAlergias();
        this.cargarDiagnosticos();
        this.cargarTipoSangre();
        
      } catch (error) {
        console.error('Error parseando paciente de localStorage:', error);
        this.mostrarError('Error al obtener datos del paciente');
      }
    } else {
      console.warn('⚠️ No se encontró paciente en localStorage');
      this.mostrarError('No se encontró sesión activa. Por favor, inicie sesión.');
    }
  }

  getCompatibilidadSangre(tipo: string): { puedeDonar: string[], puedeRecibir: string[] } {
    const compatibilidad = {
      'A+': { 
        puedeDonar: ['A+', 'AB+'], 
        puedeRecibir: ['A+', 'A-', 'O+', 'O-'] 
      },
      'A-': { 
        puedeDonar: ['A+', 'A-', 'AB+', 'AB-'], 
        puedeRecibir: ['A-', 'O-'] 
      },
      'B+': { 
        puedeDonar: ['B+', 'AB+'], 
        puedeRecibir: ['B+', 'B-', 'O+', 'O-'] 
      },
      'B-': { 
        puedeDonar: ['B+', 'B-', 'AB+', 'AB-'], 
        puedeRecibir: ['B-', 'O-'] 
      },
      'AB+': { 
        puedeDonar: ['AB+'], 
        puedeRecibir: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'] 
      },
      'AB-': { 
        puedeDonar: ['AB+', 'AB-'], 
        puedeRecibir: ['AB-', 'A-', 'B-', 'O-'] 
      },
      'O+': { 
        puedeDonar: ['A+', 'B+', 'AB+', 'O+'], 
        puedeRecibir: ['O+', 'O-'] 
      },
      'O-': { 
        puedeDonar: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'], 
        puedeRecibir: ['O-'] 
      }
    };
    return compatibilidad[tipo as keyof typeof compatibilidad] || { puedeDonar: [], puedeRecibir: [] };
  }

  cargarTipoSangre() {
    if (!this.pacienteId) return;
    
    this.isLoadingSangre = true;
    this.errorSangre = '';
    
    this.pacienteService.getTipoSangreByPacienteId(this.pacienteId).subscribe({
      next: (data) => {
        this.tipoSangre = data.tiposangre;
        this.isLoadingSangre = false;
        console.log('Tipo de sangre cargado:', this.tipoSangre);
      },
      error: (error) => {
        console.error('Error cargando tipo de sangre:', error);
        this.errorSangre = 'Error al cargar el tipo de sangre';
        this.isLoadingSangre = false;
      }
    });
  }

  cargarAlergias() {
    if (!this.pacienteId) return;
    
    this.isLoadingAlergias = true;
    this.errorAlergias = '';
    
    this.pacienteService.getAlergiasByPacienteId(this.pacienteId).subscribe({
      next: (alergias) => {
        this.alergias = alergias;
        this.isLoadingAlergias = false;
        console.log('Alergias cargadas:', this.alergias);
      },
      error: (error) => {
        console.error('Error cargando alergias:', error);
        this.errorAlergias = 'Error al cargar las alergias';
        this.isLoadingAlergias = false;
      }
    });
  }

  cargarDiagnosticos() {
    if (!this.pacienteId) return;
    
    this.isLoadingDiagnosticos = true;
    this.errorDiagnosticos = '';
    
    this.pacienteService.getDiagnosticosByPacienteId(this.pacienteId).subscribe({
      next: (diagnosticos) => {
        this.diagnosticos = diagnosticos;
        this.isLoadingDiagnosticos = false;
        console.log('Diagnósticos cargados:', this.diagnosticos);
      },
      error: (error) => {
        console.error('Error cargando diagnósticos:', error);
        this.errorDiagnosticos = 'Error al cargar las condiciones médicas';
        this.isLoadingDiagnosticos = false;
      }
    });
  }

  mostrarError(mensaje: string) {
    this.errorAlergias = mensaje;
    this.errorDiagnosticos = mensaje;
    this.isLoadingAlergias = false;
    this.isLoadingDiagnosticos = false;
  }

  reiniciarDatos() {
    this.alergias = [];
    this.diagnosticos = [];
    this.tipoSangre = '';
    
    this.mostrarAlergias = false;
    this.mostrarCondiciones = false;
    this.mostrarSangre = false;
    
    this.isLoadingAlergias = true;
    this.isLoadingDiagnosticos = true;
    this.isLoadingSangre = true;
    
    this.errorAlergias = '';
    this.errorDiagnosticos = '';
    this.errorSangre = '';
    
    console.log('🔄 Datos reiniciados para nuevo paciente');
  }

   toggleAlergia() {
    this.mostrarAlergias = !this.mostrarAlergias;
  }

   toggleCondicion() {
    this.mostrarCondiciones = !this.mostrarCondiciones;
  }

   toggleSangre() {
    this.mostrarSangre = !this.mostrarSangre;
  }
}
