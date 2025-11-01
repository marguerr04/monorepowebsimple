import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule } from '@angular/router';
import { PacienteHeaderComponent } from '../componentes/paciente-header/paciente-header.component';
import { CabezaPerfilComponent } from '../componentes/cabeza-perfil/cabeza-perfil.component';
import {IonHeader, IonToolbar, IonTitle, IonContent, IonCard, IonCardHeader, IonCardContent, IonButton,
  IonList, IonItem, IonLabel, IonBreadcrumbs, IonBreadcrumb, IonButtons, IonMenuButton,} from '@ionic/angular/standalone';

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

  patientName = 'Juan Pérez | id: 123';
  patientBlood = 'AB-';
  patientNemergency = '+56 9 1234 5678';

  constructor() { }

  ngOnInit() {
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
