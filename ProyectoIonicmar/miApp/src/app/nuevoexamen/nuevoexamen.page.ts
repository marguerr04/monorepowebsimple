import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';
import { IonButton } from '@ionic/angular/standalone';
import { NuevoArchivoComponent } from '@app/componentes/nuevo-archivo/nuevo-archivo.component';
import { BackendService } from '@app/core/servicios/backend.service';

@Component({
  selector: 'app-nuevoexamen',
  templateUrl: './nuevoexamen.page.html',
  styleUrls: ['./nuevoexamen.page.scss'],
  standalone: true,
  imports: [ CommonModule, IonButton, NuevoArchivoComponent ]
})

export class NuevoexamenPage {
  
  constructor(
    private router: Router,
    private backendService: BackendService
  ) {}

  onArchivoGuardado(datos: any) {
    console.log('🔬 Examen a guardar:', datos);
    
    this.backendService.guardarExamen(datos).subscribe({
      next: (response) => {
        console.log('✅ Examen guardado en BD:', response);
        this.router.navigate(['/examenes']);
      },
      error: (error) => {
        console.error('❌ Error guardando examen:', error);
        alert('Error al guardar el examen: ' + error.message);
      }
    });
  }

  onCancelado() {
    this.router.navigate(['/examenes']);
  }
}