import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule, FormBuilder, Validators } from '@angular/forms';
import {
  IonContent, IonHeader, IonTitle, IonToolbar,
  IonList, IonItem, IonLabel, IonInput, IonButton, IonNote,
  IonToast, ToastController, IonButtons, IonMenuButton, IonBreadcrumbs, IonBreadcrumb
} from '@ionic/angular/standalone';
import { Observable } from 'rxjs';
import { ConsultasService } from '../core/servicios/consultas';
import { Consulta } from '../core/models/ficha-medica';
import { RouterModule } from '@angular/router';

@Component({
  selector: 'app-gestion-consultas',
  standalone: true,
  templateUrl: './gestion-consultas.page.html',
  styleUrls: ['./gestion-consultas.page.scss'],
  imports: [
    CommonModule, ReactiveFormsModule,
    IonContent, IonHeader, IonTitle, IonToolbar,
    IonList, IonItem, IonLabel, IonInput, IonButton, IonNote,
    IonToast, IonButtons, IonMenuButton, IonBreadcrumbs, IonBreadcrumb,
    RouterModule
  ],
})
export class GestionConsultasPage implements OnInit {
  private fb = inject(FormBuilder);
  private consultasSrv = inject(ConsultasService);
  private toastCtrl = inject(ToastController);

  consultas$!: Observable<Consulta[]>;
  isEditing = false;
  editingId: string | null = null;

  form = this.fb.group({
    motivo: ['', [Validators.required, Validators.minLength(5)]],
    diagnostico: [''],
    pacienteId: ['PAC001', Validators.required]
  });

  ngOnInit() {
    this.consultas$ = this.consultasSrv.listar();
  }

  async agregar() {
    if (this.form.invalid) return;
    
    try {
      const { motivo, diagnostico, pacienteId } = this.form.value;
      
      if (this.isEditing && this.editingId) {
        await this.consultasSrv.actualizar(this.editingId, {
          motivo: motivo!,
          diagnostico: diagnostico || undefined
        });
        this.mostrarMensaje('Consulta actualizada con éxito', 'success');
        this.cancelarEdicion();
      } else {
        await this.consultasSrv.agregar({ 
          motivo: motivo!, 
          diagnostico: diagnostico || undefined,
          pacienteId: pacienteId!
        });
        this.mostrarMensaje('Consulta creada con éxito', 'success');
      }
      
      this.form.reset();
      this.form.patchValue({ pacienteId: 'PAC001' });
      
    } catch (error) {
      console.error('Error:', error);
      this.mostrarMensaje('Error al crear consulta', 'danger');
    }
  }

  editar(consulta: Consulta) {
    this.isEditing = true;
    this.editingId = consulta.id || null;
    
    this.form.patchValue({
      motivo: consulta.motivo,
      diagnostico: consulta.diagnostico,
      pacienteId: consulta.pacienteId
    });
  }

  cancelarEdicion() {
    this.isEditing = false;
    this.editingId = null;
    this.form.reset();
    this.form.patchValue({ pacienteId: 'PAC001' });
  }

  eliminar(consulta: Consulta) {
    if (consulta.id) {
      try {
        this.consultasSrv.eliminar(consulta.id);
        this.mostrarMensaje('Consulta eliminada con éxito', 'success');
      } catch (error) {
        this.mostrarMensaje('Error al eliminar consulta', 'danger');
      }
    }
  }

  async mostrarMensaje(mensaje: string, color: string) {
    const toast = await this.toastCtrl.create({
      message: mensaje,
      duration: 3000,
      color: color,
      position: 'bottom'
    });
    await toast.present();
  }

  get botonTexto() {
    return this.isEditing ? 'Actualizar' : 'Agregar';
  }
}