import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule } from '@angular/router';
import { Router } from '@angular/router';
import { IonContent, IonButton, IonHeader, IonTitle, IonAlert,
  IonToolbar, IonItem, IonLabel, IonInput, IonSpinner } from '@ionic/angular/standalone';
import { BackendService } from '@app/core/servicios/backend.service';

@Component({
  selector: 'app-login-paciente',
  templateUrl: './login-paciente.page.html',
  styleUrls: ['./login-paciente.page.scss'],
  standalone: true,
  imports: [IonContent, IonButton, IonHeader, IonTitle, IonToolbar, IonSpinner, IonAlert,
    IonItem, IonLabel, IonInput, RouterModule, CommonModule, FormsModule]
})
export class LoginPacientePage implements OnInit {
  rut: string = '';
  correo: string = '';
  clave: string = '';
  isLoading: boolean = false;
  showAlert: boolean = false;
  alertMessage: string = '';

  validarFormulario(): boolean {
    const rutValido = this.validarRUT();
    const emailValido = this.validarEmail();
    const claveValida = this.clave.length >= 8;
    return rutValido && emailValido && claveValida;
  }

  validarEmail(): boolean {
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(this.correo);
  }

  validarRUT(): boolean {
    const rutLimpio = this.rut.replace(/[^0-9kK]/g, '');
    return rutLimpio.length >= 8 && rutLimpio.length <= 9;
  }

  formatearRUT() {
    if (this.rut.length > 0) {
      let rutLimpio = this.rut.replace(/[^0-9kK]/g, '');
      
      if (rutLimpio.length > 1) {
        const cuerpo = rutLimpio.slice(0, -1);
        const dv = rutLimpio.slice(-1).toUpperCase();
        
        let rutFormateado = cuerpo.toString().replace(/\B(?=(\d{3})+(?!\d))/g, '.');
        rutFormateado = rutFormateado + '-' + dv;
        
        this.rut = rutFormateado;
      }
    }
  }

  async enviar() {
    if (!this.validarFormulario()) {
      this.mostrarAlerta('Por favor, complete todos los campos correctamente');
      return;
    }

    this.isLoading = true;

    try {
      const rutLimpio = this.rut.replace(/[^0-9kK]/g, '');
      
      console.log('🔐 Intentando login con:', {
        rutOriginal: this.rut,
        rutLimpio: rutLimpio,
        correo: this.correo,
        clave: this.clave
      });

      console.log('🔍 Buscando paciente con RUT limpio:', rutLimpio);

      const loginResult = await this.backendService.loginPaciente(
        rutLimpio,
        this.correo,
        this.clave
      ).toPromise();

      console.log('✅ Respuesta del login:', loginResult);

      if (loginResult.success) {
        console.log('🎉 Login exitoso:', loginResult.paciente);
        
        localStorage.setItem('pacienteActual', JSON.stringify(loginResult.paciente));
        
        this.router.navigate(['/home'], {
          state: { paciente: loginResult.paciente }
        });
      } else {
        this.mostrarAlerta('Credenciales incorrectas. Verifique su correo y clave.');
      }

    } catch (error: any) {
      console.error('❌ Error completo en login:', error);
      
      if (error.status === 401) {
        this.mostrarAlerta('Credenciales incorrectas. Verifique su correo y clave.');
      } else if (error.status === 404) {
        this.mostrarAlerta('Paciente no encontrado con el RUT proporcionado.');
      } else {
        this.mostrarAlerta('Error del servidor. Intente nuevamente.');
      }
    } finally {
      this.isLoading = false;
    }
  }

  mostrarAlerta(mensaje: string) {
    this.alertMessage = mensaje;
    this.showAlert = true;
  }

  constructor(
    private backendService: BackendService,
    private router: Router
  ) { }

  ngOnInit() {
  }
}