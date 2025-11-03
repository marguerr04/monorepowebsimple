import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';
import { NuevoArchivoComponent } from '@app/componentes/nuevo-archivo/nuevo-archivo.component';
import { BackendService } from '@app/core/servicios/backend.service';

@Component({
  selector: 'app-nuevaconsulta',
  templateUrl: './nuevaconsulta.page.html',
  styleUrls: ['./nuevaconsulta.page.scss'],
  standalone: true,
  imports: [CommonModule, NuevoArchivoComponent]
})

export class NuevaconsultaPage {
  
  constructor(
    private router: Router,
    private backendService: BackendService
  ) {}

  onArchivoGuardado(datos: any) {
    console.log('📋 Consulta a guardar:', datos);
    
    this.backendService.guardarConsulta(datos).subscribe({
      next: (response) => {
        console.log('✅ Consulta guardada en BD:', response);
        this.router.navigate(['/paginamar2']);
      },
      error: (error) => {
        console.error('❌ Error guardando consulta:', error);
        alert('Error al guardar la consulta: ' + error.message);
      }
    });
  }

  onCancelado() {
    this.router.navigate(['/paginamar2']);
  }
}