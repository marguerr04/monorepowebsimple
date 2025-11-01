import { Injectable } from '@angular/core';
import { Camera, CameraResultType, CameraSource, Photo } from '@capacitor/camera';
import { Filesystem, Directory } from '@capacitor/filesystem';
import { Preferences } from '@capacitor/preferences';

@Injectable({
  providedIn: 'root'
})
export class CameraService {

  constructor() { }

  /**
   * Tomar una foto con la cámara
   * @returns Promise con la imagen en formato DataUrl (base64)
   */
  async tomarFoto(): Promise<string> {
    try {
      const image = await Camera.getPhoto({
        quality: 90,
        allowEditing: false,
        resultType: CameraResultType.DataUrl,
        source: CameraSource.Camera,
        saveToGallery: true, // Guardar en la galería del dispositivo
        promptLabelHeader: 'Tomar Foto',
        promptLabelPhoto: 'Desde Galería',
        promptLabelPicture: 'Desde Cámara'
      });

      // image.dataUrl contiene la imagen en formato base64
      return image.dataUrl || '';

    } catch (error) {
      console.error('Error al tomar foto:', error);
      throw new Error('No se pudo tomar la foto. Asegúrate de dar los permisos necesarios.');
    }
  }

  /**
   * Seleccionar una foto de la galería
   * @returns Promise con la imagen en formato DataUrl (base64)
   */
  async seleccionarDeGaleria(): Promise<string> {
    try {
      const image = await Camera.getPhoto({
        quality: 90,
        allowEditing: false,
        resultType: CameraResultType.DataUrl,
        source: CameraSource.Photos
      });

      return image.dataUrl || '';

    } catch (error) {
      console.error('Error al seleccionar de galería:', error);
      throw new Error('No se pudo seleccionar la foto de la galería.');
    }
  }

  /**
   * Convertir DataUrl a Blob (útil para enviar a servidor)
   * @param dataUrl Imagen en formato DataUrl
   * @returns Blob de la imagen
   */
  dataUrlToBlob(dataUrl: string): Blob {
    const arr = dataUrl.split(',');
    const mime = arr[0].match(/:(.*?);/)?.[1] || 'image/jpeg';
    const bstr = atob(arr[1]);
    let n = bstr.length;
    const u8arr = new Uint8Array(n);
    
    while (n--) {
      u8arr[n] = bstr.charCodeAt(n);
    }
    
    return new Blob([u8arr], { type: mime });
  }

  /**
   * Guardar foto en el almacenamiento local
   * @param dataUrl Imagen en formato DataUrl
   * @param key Clave para guardar en Preferences
   */
  async guardarFotoLocalmente(dataUrl: string, key: string): Promise<void> {
    await Preferences.set({
      key: key,
      value: dataUrl
    });
  }

  /**
   * Cargar foto del almacenamiento local
   * @param key Clave de la foto guardada
   * @returns DataUrl de la imagen o null si no existe
   */
  async cargarFotoLocalmente(key: string): Promise<string | null> {
    const result = await Preferences.get({ key: key });
    return result.value;
  }

  /**
   * Eliminar foto del almacenamiento local
   * @param key Clave de la foto a eliminar
   */
  async eliminarFotoLocalmente(key: string): Promise<void> {
    await Preferences.remove({ key: key });
  }

  /**
   * Verificar si la cámara está disponible
   * @returns Promise<boolean>
   */
  async camaraDisponible(): Promise<boolean> {
    try {
      // Intentar acceder a la cámara para verificar permisos
      await Camera.checkPermissions();
      return true;
    } catch (error) {
      console.warn('Cámara no disponible:', error);
      return false;
    }
  }

  /**
   * Solicitar permisos de cámara
   * @returns Promise<boolean>
   */
  async solicitarPermisosCamara(): Promise<boolean> {
    try {
      const permissions = await Camera.requestPermissions();
      return permissions.camera === 'granted' && permissions.photos === 'granted';
    } catch (error) {
      console.error('Error al solicitar permisos:', error);
      return false;
    }
  }
}