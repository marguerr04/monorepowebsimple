import { Component, OnInit } from '@angular/core';
import { BackendService } from 'src/app/core/servicios/backend.service';
import { IonicModule } from '@ionic/angular'; 
import { CommonModule } from '@angular/common'; 

@Component({
  selector: 'app-test-conexion',
  templateUrl: './test-conexion.page.html',
  styleUrls: ['./test-conexion.page.scss'],
  standalone: true,
  imports: [IonicModule, CommonModule], // 👈 Agrega aquí IonicModule y CommonModule
})
export class TestConexionPage implements OnInit {
  status: string = 'Conectando...';

  constructor(private backend: BackendService) {}

  ngOnInit() {
    this.backend.testConnection().subscribe({
      next: (res: any) => (this.status = '✅ Conectado: ' + JSON.stringify(res)),
      error: (err: any) => (this.status = '❌ Error: ' + err.message),
    });
  }
}
