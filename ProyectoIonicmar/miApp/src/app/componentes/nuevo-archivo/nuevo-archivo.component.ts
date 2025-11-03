import { Component, Input, Output, EventEmitter, ViewChild, ElementRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { 
  IonHeader, IonToolbar, IonTitle, IonContent, IonButton, 
  IonIcon, IonInput, IonItem, IonLabel, IonTextarea,
  AlertController , IonSelect, IonSelectOption
} from '@ionic/angular/standalone';
import { CameraService } from '@app/services/camera';
import { addIcons } from 'ionicons';
import { cameraOutline, imagesOutline, folderOutline, trashOutline } from 'ionicons/icons';
import { BackendService } from '@app/core/servicios/backend.service';

@Component({
  selector: 'app-nuevo-archivo',
  templateUrl: './nuevo-archivo.component.html',
  styleUrls: ['./nuevo-archivo.component.scss'],
  standalone: true,
  imports: [
    CommonModule, 
    FormsModule,
    IonHeader, IonToolbar, IonTitle, IonContent, IonSelect, IonSelectOption,
    IonButton, IonIcon, IonInput, IonItem, IonLabel, IonTextarea
  ]
})
export class NuevoArchivoComponent {
  @ViewChild('fileInput', { static: false }) fileInput!: ElementRef<HTMLInputElement>;
  
  @Input() titulo: string = 'Subir Nuevo Archivo';
  @Input() tipo: 'consulta' | 'examen' = 'consulta';
  @Input() textoBotonGuardar: string = 'Añadir';
  @Input() rutaCancelar: string = '/home';
  
  @Output() archivoGuardado = new EventEmitter<any>();
  @Output() cancelado = new EventEmitter<void>();

  fecha: string = '';
  centroMedico: string = '';
  archivoSeleccionado: File | null = null;
  fotoTomada: string | null = null;

  motivoConsulta: string = '';
  tipoExamen: string = '';
  resultadoExamen: string = '';

  tiposExamen: any[] = [];
  centrosMedicos: any[] = [];
  isLoadingListas: boolean = false;

  constructor(
    private backendService: BackendService,
    private cameraService: CameraService,
    private alertController: AlertController
  ) {
    addIcons({
      'camera-outline': cameraOutline,
      'images-outline': imagesOutline,
      'folder-outline': folderOutline,
      'trash-outline': trashOutline
    });
  }

  ngOnInit() {
    this.cargarListas();
  }

  cargarListas() {
    this.isLoadingListas = true;

    this.backendService.getCentrosMedicos().subscribe({
      next: (centros) => {
        this.centrosMedicos = centros;
        console.log('🏥 Centros médicos cargados:', centros);
        
        if (this.tipo === 'examen') {
          this.cargarTiposExamen();
        } else {
          this.isLoadingListas = false;
        }
      },
      error: (error) => {
        console.error('❌ Error cargando centros médicos:', error);
        this.isLoadingListas = false;
      }
    });
  }

  cargarTiposExamen() {
    this.backendService.getTiposExamen().subscribe({
      next: (tipos) => {
        this.tiposExamen = tipos;
        console.log('🔬 Tipos de examen cargados:', tipos);
        this.isLoadingListas = false;
      },
      error: (error) => {
        console.error('❌ Error cargando tipos de examen:', error);
        this.isLoadingListas = false;
      }
    });
  }

  async tomarFoto() {
    try {
      const permisos = await this.cameraService.solicitarPermisosCamara();
      
      if (!permisos) {
        await this.mostrarMensaje('Error', 'Se necesitan permisos de cámara para tomar fotos');
        return;
      }

      const fotoDataUrl = await this.cameraService.tomarFoto();
      this.fotoTomada = fotoDataUrl;
      
      const nombreArchivo = `foto-${this.tipo}-${new Date().getTime()}`;
      await this.cameraService.guardarFotoLocalmente(fotoDataUrl, nombreArchivo);
      
      await this.mostrarMensaje('Éxito', 'Foto tomada correctamente');
    } catch (error: any) {
      console.error('Error al tomar foto:', error);
      await this.mostrarMensaje('Error', error.message || 'No se pudo tomar la foto');
    }
  }

  async seleccionarDeGaleria() {
    try {
      const fotoDataUrl = await this.cameraService.seleccionarDeGaleria();
      this.fotoTomada = fotoDataUrl;
    } catch (error: any) {
      console.error('Error al seleccionar foto:', error);
      await this.mostrarMensaje('Error', error.message || 'No se pudo seleccionar la foto');
    }
  }

  onFileSelected(event: any) {
    const file = event.target.files[0];
    if (file) {
      this.archivoSeleccionado = file;
      console.log("Archivo seleccionado:", file.name, file.type, file.size);
      this.mostrarMensaje('Archivo seleccionado', `Se ha seleccionado: ${file.name}`);
    }
  }

  openFilePicker() {
    this.fileInput.nativeElement.click();
  }

async guardar() {
  if (!this.fecha) {
    await this.mostrarMensaje('Error', 'Por favor selecciona una fecha');
    return;
  }

  if (this.tipo === 'consulta') {
    if (!this.motivoConsulta.trim()) {
      await this.mostrarMensaje('Error', 'Por favor ingresa el motivo de la consulta');
      return;
    }
  } else if (this.tipo === 'examen') {
    if (!this.tipoExamen.trim()) {
      await this.mostrarMensaje('Error', 'Por favor ingresa el tipo de examen');
      return;
    }
  }

  const pacienteGuardado = localStorage.getItem('pacienteActual');
  if (!pacienteGuardado) {
    await this.mostrarMensaje('Error', 'No se encontró sesión de paciente');
    return;
  }

  const paciente = JSON.parse(pacienteGuardado);
  const pacienteId = paciente.id;

  const datos = {
    tipo: this.tipo,
    fecha: this.fecha,
    centroMedico: this.centroMedico,
    
    motivoConsulta: this.motivoConsulta,
    tipoExamen: this.tipoExamen,
    resultadoExamen: this.resultadoExamen,
    
    pacienteId: pacienteId,
    
    tieneArchivo: !!this.archivoSeleccionado,
    tieneFoto: !!this.fotoTomada,
    nombreArchivo: this.archivoSeleccionado?.name || null
  };

  console.log('Guardando datos básicos:', datos);
  
  this.archivoGuardado.emit(datos);
  
  await this.mostrarMensaje('Éxito', `${this.tipo === 'consulta' ? 'Consulta' : 'Examen'} guardado correctamente`);
}

  cancelar() {
    this.cancelado.emit();
  }

  eliminarFoto() {
    this.fotoTomada = null;
  }

  protected async mostrarMensaje(header: string, message: string) {
    const alert = await this.alertController.create({
      header,
      message,
      buttons: ['OK']
    });
    await alert.present();
  }

  mostrarCampoConsulta(): boolean {
    return this.tipo === 'consulta';
  }

  mostrarCampoExamen(): boolean {
    return this.tipo === 'examen';
  }
}