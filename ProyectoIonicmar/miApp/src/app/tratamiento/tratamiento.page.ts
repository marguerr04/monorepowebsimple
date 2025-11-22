import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule } from '@angular/router';
import { PacienteHeaderComponent } from '../componentes/paciente-header/paciente-header.component';
import { CabezaPerfilComponent } from '../componentes/cabeza-perfil/cabeza-perfil.component';
import { PacienteService, Tratamiento } from '@app/services/paciente.service';
import {
  IonHeader, IonToolbar, IonTitle, IonContent, IonCard, IonCardHeader, IonCardContent, IonButton,
  IonList, IonItem, IonLabel, IonBreadcrumbs, IonBreadcrumb, IonButtons, IonMenuButton,
  IonChip, IonBadge, IonIcon
} from '@ionic/angular/standalone';
import { addIcons } from 'ionicons';
import { medical, calendar, time, alertCircle } from 'ionicons/icons';

@Component({
  selector: 'app-tratamiento',
  templateUrl: './tratamiento.page.html',
  styleUrls: ['./tratamiento.page.scss'],
  standalone: true,
  imports: [
    IonContent, IonHeader, IonTitle, IonList, IonToolbar, CommonModule, RouterModule,
    IonCard, IonCardHeader, IonCardContent, IonButton, IonItem, IonLabel, 
    IonBreadcrumbs, IonBreadcrumb, IonButtons, IonMenuButton, IonChip, IonBadge, IonIcon,
    PacienteHeaderComponent, FormsModule, CabezaPerfilComponent
  ]
})
export class TratamientoPage implements OnInit {
  tratamientos: Tratamiento[] = [];
  isLoading: boolean = true;
  error: string = '';
  pacienteId: number | null = null;

  constructor(private pacienteService: PacienteService) {
    addIcons({ medical, calendar, time, alertCircle });
  }

  ngOnInit() {
    this.cargarTratamiento();
  }

  cargarTratamiento() {
    // Obtener el ID del paciente logueado
    const pacienteGuardado = localStorage.getItem('pacienteActual');
    
    if (!pacienteGuardado) {
      this.error = 'No se encontró sesión de paciente';
      this.isLoading = false;
      return;
    }

    try {
      const paciente = JSON.parse(pacienteGuardado);
      this.pacienteId = paciente.id;

      if (!this.pacienteId) {
        this.error = 'ID de paciente no válido';
        this.isLoading = false;
        return;
      }

      this.pacienteService.getTratamientoByPacienteId(this.pacienteId).subscribe({
        next: (tratamientos) => {
          this.tratamientos = tratamientos;
          this.isLoading = false;
          console.log('Tratamientos cargados:', this.tratamientos);
        },
        error: (error) => {
          console.error('Error cargando tratamiento:', error);
          this.error = 'Error al cargar el tratamiento';
          this.isLoading = false;
        }
      });

    } catch (error) {
      console.error('Error parseando paciente:', error);
      this.error = 'Error al obtener datos del paciente';
      this.isLoading = false;
    }
  }

  formatearFecha(fecha: string): string {
    if (!fecha) return '';
    return new Date(fecha).toLocaleDateString('es-ES');
  }

  getColorPermanente(espermanente: boolean): string {
    return espermanente ? 'warning' : 'success';
  }

  getTextoPermanente(espermanente: boolean): string {
    return espermanente ? 'Tratamiento permanente' : 'Tratamiento temporal';
  }
}