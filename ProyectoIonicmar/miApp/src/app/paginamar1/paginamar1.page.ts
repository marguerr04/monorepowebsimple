import { Component } from '@angular/core';
import { RouterModule } from '@angular/router';
import { PacienteHeaderComponent } from '../componentes/paciente-header/paciente-header.component';
import { CardContentComponent } from '../componentes/card-content/card-content.component';
import {
  IonHeader,
  IonToolbar,
  IonTitle,
  IonContent,
  IonCard,
  IonCardHeader,
  IonCardContent,
  IonButton,
  IonList,
  IonItem,
  IonLabel,
  IonBreadcrumbs,
  IonBreadcrumb, 
  IonButtons,
  IonMenuButton,
} from '@ionic/angular/standalone';

@Component({
  selector: 'app-paginamar1',
  templateUrl: 'paginamar1.page.html',
  styleUrls: ['paginamar1.page.scss'],
  standalone: true,
  imports: [
    RouterModule,
    PacienteHeaderComponent,
    CardContentComponent,
    IonHeader,
    IonToolbar,
    IonTitle,
    IonContent,
    IonCard,
    IonCardHeader,
    IonCardContent,
    IonButton,
    IonList,
    IonItem,
    IonLabel,
    IonBreadcrumbs,
    IonBreadcrumb,
    IonButtons,
    IonMenuButton,
  ],
})
export class Paginamar1Page {
  public patientName: string = 'Juan Peréz';
  public totalScans: number = 4;

  constructor() {}
  
  verConsultas() {
    console.log('Navegando a la sección de consultas...');
  }

  verExamenes() {
    console.log('Navegando a la sección de exámenes...');
  }

  verOperaciones() {
    console.log('Navegando a la sección de operaciones...');
  }

  generarPdf() {
    console.log('Generando PDF con datos anonimizados...');
  }
}