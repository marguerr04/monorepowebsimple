import { Component } from '@angular/core';
import { IonicModule } from '@ionic/angular'; // Asegúrate de importar IonicModule
import { RouterModule } from '@angular/router';
@Component({
  selector: 'app-paginamar1',
  templateUrl: 'paginamar1.page.html',
  styleUrls: ['paginamar1.page.scss'],
  standalone: true, // Importante para las versiones recientes de Ionic/Angular
  imports: [IonicModule, RouterModule], // Y añadirlo a los imports del componente
})
export class Paginamar1Page {
  


  // Variables que se mostrarán en la interfaz
  public patientName: string = 'xxxx';
  public totalScans: number = 4;

  constructor() {}

  // Función para el botón "Consultas"
  verConsultas() {
    console.log('Navegando a la sección de consultas...')
    //this.router.navigate(['/paginamar2']);
    // Aquí irá la lógica para mostrar las consultas
  }

  // Función para el botón "Exámenes"
  verExamenes() {
    console.log('Navegando a la sección de exámenes...');
    // Aquí irá la lógica para ver los exámenes
  }

  // Función para el botón "Operaciones"
  verOperaciones() {
    console.log('Navegando a la sección de operaciones...');
    // Aquí irá la lógica para ver las operaciones
  }

  // Función para generar el PDF
  generarPdf() {
    console.log('Generando PDF con datos anonimizados...');
    // Aquí irá la lógica para crear y exportar el archivo PDF
  }

}

