import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';
import { NuevoArchivoComponent } from '@app/componentes/nuevo-archivo/nuevo-archivo.component';

@Component({
  selector: 'app-nuevaconsulta',
  templateUrl: './nuevaconsulta.page.html',
  styleUrls: ['./nuevaconsulta.page.scss'],
  standalone: true,
  imports: [CommonModule, NuevoArchivoComponent]
})

export class NuevaconsultaPage {
  
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
    // Redirigir a la página de consultas sin guardar
    this.router.navigate(['/paginamar2']);
  }
}