import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';
import { IonButton } from '@ionic/angular/standalone';
import { NuevoArchivoComponent } from '@app/componentes/nuevo-archivo/nuevo-archivo.component';

@Component({
  selector: 'app-nuevoexamen',
  templateUrl: './nuevoexamen.page.html',
  styleUrls: ['./nuevoexamen.page.scss'],
  standalone: true,
  imports: [ CommonModule, IonButton, NuevoArchivoComponent ]
})

export class NuevoexamenPage {
  
  constructor(private router: Router) {}

  onArchivoGuardado(datos: any) {
    console.log('📋 Consulta guardada:', datos);
    
    // Aquí puedes enviar los datos al backend
    // Ejemplo:
    // this.backendService.guardarConsulta(datos).subscribe(...)
    
    // Redirigir a la página de consultas después de guardar
    this.router.navigate(['/paginamar2']);
  }

  onCancelado() {
    this.router.navigate(['/examenes']);
  }
}