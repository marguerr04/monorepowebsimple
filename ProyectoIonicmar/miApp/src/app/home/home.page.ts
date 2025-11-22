import { Component, OnInit, ViewChild, ElementRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router, RouterModule } from '@angular/router';
import {
  IonContent, IonHeader, IonTitle, IonToolbar, IonGrid, IonSpinner,
  IonRow, IonCol, IonCard, IonCardHeader, IonCardContent,
  IonItem, IonAvatar, IonLabel, IonCardTitle, IonCardSubtitle,
  IonButton, IonIcon, IonList, IonButtons, IonMenuButton, IonModal,
  IonActionSheet, AlertController, ActionSheetButton
} from '@ionic/angular/standalone';
import { CabezaPerfilComponent } from '../componentes/cabeza-perfil/cabeza-perfil.component';
import { BloqueContenidoComponent } from '@app/componentes/bloque-contenido/bloque-contenido.component';
import { BackendService } from '@app/core/servicios/backend.service';
import { CameraService } from '@app/services/camera';
import { addIcons } from 'ionicons';
import { camera, images, document, download } from 'ionicons/icons';
import jsPDF from 'jspdf';

@Component({
  selector: 'app-home',
  templateUrl: 'home.page.html',
  styleUrls: ['home.page.scss'],
  standalone: true,
  imports: [
    CommonModule, RouterModule,
    IonContent, IonHeader, IonTitle, IonToolbar, IonGrid, IonSpinner,
    IonRow, IonCol, IonCard, IonCardHeader, IonCardContent,
    IonItem, IonAvatar, IonLabel, IonCardTitle, IonCardSubtitle, IonModal,
    IonButton, IonIcon, IonList, IonButtons, IonMenuButton, CabezaPerfilComponent, BloqueContenidoComponent,
    IonActionSheet
  ],
})
export class HomePage implements OnInit {
  @ViewChild('fileInput') fileInput!: ElementRef<HTMLInputElement>;

  pacienteActual: any = null;
  institucionMedica: string = 'Cargando...';

  imagenFichaMedica: string | null = null;
  mostrarActionSheet: boolean = false;
  archivoSubido: File | null = null;

  constructor(
    private router: Router, 
    private backendService: BackendService,
    private cameraService: CameraService,
    private alertController: AlertController
  ) {
    addIcons({ camera, images, document, download });
  }

  ngOnInit() {
    this.cargarPacienteActual();
    this.testConnection();
  }

  actionSheetButtons: ActionSheetButton[] = [
    {
      text: 'Tomar Foto',
      icon: 'camera',
      handler: () => {
        this.tomarFotoFicha();
        return false;
      }
    },
    {
      text: 'Galería',
      icon: 'images',
      handler: () => {
        this.seleccionarDeGaleriaFicha();
        return false;
      }
    },
    {
      text: 'Archivo',
      icon: 'document',
      handler: () => {
        this.abrirSelectorArchivos();
        return false;
      }
    },
    {
      text: 'Cancelar',
      role: 'cancel',
      handler: () => {
        this.mostrarActionSheet = false;
      }
    }
  ];

  async mostrarOpcionesSubir() {
    this.mostrarActionSheet = true;
  }

  async tomarFotoFicha() {
    try {
      const fotoDataUrl = await this.cameraService.tomarFoto();
      this.imagenFichaMedica = fotoDataUrl;
      this.archivoSubido = null;
      await this.mostrarMensaje('Éxito', 'Foto de ficha médica tomada correctamente');
    } catch (error: any) {
      console.error('Error tomando foto:', error);
      await this.mostrarMensaje('Error', error.message || 'No se pudo tomar la foto');
    } finally {
      this.mostrarActionSheet = false;
    }
  }

  async seleccionarDeGaleriaFicha() {
    try {
      const fotoDataUrl = await this.cameraService.seleccionarDeGaleria();
      this.imagenFichaMedica = fotoDataUrl;
      this.archivoSubido = null;
      await this.mostrarMensaje('Éxito', 'Imagen seleccionada correctamente');
    } catch (error: any) {
      console.error('Error seleccionando imagen:', error);
      await this.mostrarMensaje('Error', error.message || 'No se pudo seleccionar la imagen');
    } finally {
      this.mostrarActionSheet = false;
    }
  }

  abrirSelectorArchivos() {
    this.fileInput.nativeElement.click();
    this.mostrarActionSheet = false;
  }

  onFileSelected(event: any) {
    const file = event.target.files[0];
    if (file) {
      this.archivoSubido = file;
      
      if (file.type.startsWith('image/')) {
        const reader = new FileReader();
        reader.onload = (e: any) => {
          this.imagenFichaMedica = e.target.result;
          this.mostrarMensaje('Éxito', 'Archivo de imagen cargado correctamente');
        };
        reader.readAsDataURL(file);
      } else if (file.type === 'application/pdf') {
        this.imagenFichaMedica = 'assets/pdf-icon.png';
        this.mostrarMensaje('Éxito', 'Archivo PDF cargado correctamente');
      } else {
        this.mostrarMensaje('Error', 'Por favor selecciona un archivo de imagen o PDF');
      }
    }
  }

  async descargarPDF() {
    if (!this.imagenFichaMedica && !this.archivoSubido) {
      await this.mostrarMensaje('Error', 'No hay archivo para descargar');
      return;
    }

    try {
      if (this.archivoSubido && this.archivoSubido.type === 'application/pdf') {
        await this.descargarArchivoDirecto(this.archivoSubido);
        return;
      }

      if (this.imagenFichaMedica) {
        await this.convertirImagenAPDF();
      }

    } catch (error: any) {
      console.error('Error descargando PDF:', error);
      await this.mostrarMensaje('Error', 'No se pudo descargar el archivo');
    }
  }

  private async convertirImagenAPDF() {
    const pdf = new jsPDF();
    
    const pacienteGuardado = localStorage.getItem('pacienteActual');
    let nombrePaciente = 'ficha_medica';
    
    if (pacienteGuardado) {
      try {
        const paciente = JSON.parse(pacienteGuardado);
        nombrePaciente = `ficha_medica_${paciente.nombre}_${paciente.apellido}`.replace(/\s+/g, '_');
      } catch (error) {
        console.error('Error obteniendo nombre del paciente:', error);
      }
    }

    pdf.setFontSize(16);
    pdf.text('Ficha Médica', 20, 20);

    if (pacienteGuardado) {
      try {
        const paciente = JSON.parse(pacienteGuardado);
        pdf.setFontSize(12);
        pdf.text(`Paciente: ${paciente.nombre} ${paciente.apellido}`, 20, 35);
        pdf.text(`RUT: ${paciente.rut || 'No registrado'}`, 20, 45);
        pdf.text(`Fecha de descarga: ${new Date().toLocaleDateString('es-ES')}`, 20, 55);
      } catch (error) {
        console.error('Error agregando información del paciente:', error);
      }
    }

    if (this.imagenFichaMedica) {
      try {
        const imgProps = pdf.getImageProperties(this.imagenFichaMedica);
        const pdfWidth = pdf.internal.pageSize.getWidth() - 40; 
        const pdfHeight = (imgProps.height * pdfWidth) / imgProps.width;
        
        pdf.addImage(this.imagenFichaMedica, 'JPEG', 20, 70, pdfWidth, pdfHeight);
        
        const pageHeight = pdf.internal.pageSize.getHeight();
        let heightLeft = pdfHeight;
        let position = 70;

        while (heightLeft >= 0) {
          position = heightLeft - pdfHeight;
          pdf.addPage();
          pdf.addImage(this.imagenFichaMedica, 'JPEG', 20, position, pdfWidth, pdfHeight);
          heightLeft -= pageHeight;
        }
      } catch (error) {
        console.error('Error agregando imagen al PDF:', error);
        pdf.text('Error al cargar la imagen de la ficha médica', 20, 70);
      }
    } else {
      pdf.text('No hay imagen de ficha médica disponible', 20, 70);
    }

    pdf.save(`${nombrePaciente}.pdf`);
    await this.mostrarMensaje('Éxito', 'PDF descargado correctamente');
  }

  private async descargarArchivoDirecto(file: File) {
    try {
      const fileURL = URL.createObjectURL(file);

      window.open(fileURL, '_blank');
      
      await this.mostrarMensaje('Éxito', 'PDF abierto para descarga');
      
      setTimeout(() => {
        URL.revokeObjectURL(fileURL);
      }, 60000);
      
    } catch (error) {
      console.error('Error descargando archivo:', error);
      await this.mostrarMensaje('Error', 'No se pudo descargar el archivo');
    }
  }

  private async mostrarMensaje(header: string, message: string) {
    const alert = await this.alertController.create({
      header,
      message,
      buttons: ['OK']
    });
    await alert.present();
  }

  connectionStatus: string = 'Probando conexión...';
  isLoading: boolean = false;

  @ViewChild(IonModal) modal!: IonModal;
  datosPaciente = [
    { label: 'Email', valor: 'Cargando...' },
    { label: 'Teléfono', valor: 'Cargando...' },
    { label: 'Institución médica', valor: 'Cargando...' }
  ];

  botonesHome = [
  { texto: 'Consultas', ruta: '/paginamar2' },
  { texto: 'Exámenes', ruta: '/examenes' },
  { texto: 'Datos de emergencia', ruta: '/datos-emergencia', },
  { texto: 'Tratamiento', ruta: '/tratamiento' }
  ];

  modalAbierto = true;
  breakpointActual = 0.1;

  private formatearTelefono(telefono: string): string {
    if (!telefono) return '';
    
    const telefonoLimpio = telefono.replace(/\D/g, '');
    
    if (telefonoLimpio.startsWith('569') && telefonoLimpio.length === 11) {
      return `+56 9 ${telefonoLimpio.slice(3, 7)} ${telefonoLimpio.slice(7)}`;
    }
    
    if (telefonoLimpio.startsWith('56') && telefonoLimpio.length === 10) {
      return `+56 9 ${telefonoLimpio.slice(2, 6)} ${telefonoLimpio.slice(6)}`;
    }
    
    if (telefonoLimpio.startsWith('9') && telefonoLimpio.length === 9) {
      return `+56 9 ${telefonoLimpio.slice(1, 5)} ${telefonoLimpio.slice(5)}`;
    }
    
    if (telefonoLimpio.length === 8) {
      return `+56 9 ${telefonoLimpio.slice(0, 4)} ${telefonoLimpio.slice(4)}`;
    }
    
    return telefono;
  }

  cargarPacienteActual() {
    const pacienteGuardado = localStorage.getItem('pacienteActual');
    if (pacienteGuardado) {
      this.pacienteActual = JSON.parse(pacienteGuardado);
      this.actualizarDatosContacto();

      if (this.pacienteActual.centro_medico_id) {
        this.cargarCentroMedico(this.pacienteActual.centro_medico_id);
      } else {
        this.institucionMedica = 'No registrada';
        this.actualizarDatosInstitucion();
      }
    }
  }

  cargarCentroMedico(centroMedicoId: number) {
    this.backendService.getCentroMedico(centroMedicoId).subscribe({
      next: (centroMedico) => {
        console.log('🏥 Centro médico cargado:', centroMedico);
        this.institucionMedica = centroMedico.nombrecentro;
        this.actualizarDatosInstitucion();
      },
      error: (error) => {
        console.error('❌ Error cargando centro médico:', error);
        this.institucionMedica = 'No disponible';
        this.actualizarDatosInstitucion();
      }
    });
  }

  actualizarDatosInstitucion() {
    if (this.pacienteActual) {
      this.datosPaciente[2] = { 
        label: 'Institución médica', 
        valor: this.institucionMedica 
      };
    }
  }

  actualizarDatosContacto() {
    if (this.pacienteActual) {
      this.datosPaciente = [
        { label: 'Email', valor: this.pacienteActual.correo || 'No registrado' },
        { label: 'Teléfono', valor: this.formatearTelefono(this.pacienteActual.telefono) || 'No registrado' },
        { label: 'Institución médica', valor: this.institucionMedica }
      ];
    }
  }

  alternarModal() {
    if (this.breakpointActual === 0.1) {
      this.breakpointActual = 0.5; 
    } else {
      this.breakpointActual = 0.1; 
    }
  }
  cerrarModal() {
    this.modalAbierto = false;
  }

  async navegar(ruta: string) {
    if (this.modal) {
        await this.modal.dismiss(null, 'navigation');
      }
      this.router.navigateByUrl(ruta);
  }

  ionViewWillLeave() {
      if (this.modal) {
        this.modal.dismiss(null, 'leave-page');
      }
      this.modalAbierto = false;
  }
  ionViewDidEnter() {
    this.modalAbierto = true;
  }

  testConnection() {
    this.isLoading = true;
    this.backendService.testConnection().subscribe({
      next: (response) => {
        console.log('✅ Conexión exitosa:', response);
        this.connectionStatus = response.message;
        this.isLoading = false;
      },
      error: (error) => {
        console.error('❌ Error de conexión:', error);
        this.connectionStatus = 'Error conectando con el backend';
        this.isLoading = false;
      }
    });
  }

  refreshData() {
    this.testConnection();
  }
}