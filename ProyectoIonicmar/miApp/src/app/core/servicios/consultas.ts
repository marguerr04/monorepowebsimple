import { Injectable, inject } from '@angular/core';
import { 
  Firestore, 
  collection, 
  collectionData, 
  addDoc, 
  doc, 
  deleteDoc, 
  updateDoc,
  Timestamp,
  query,
  orderBy
} from '@angular/fire/firestore';
import { Observable } from 'rxjs';
import { Consulta } from '../models/ficha-medica';

@Injectable({
  providedIn: 'root'
})
export class ConsultasService {
  private firestore: Firestore = inject(Firestore);
  private ref = collection(this.firestore, 'consultas');

  constructor() { }

  listar(): Observable<Consulta[]> {
    const q = query(this.ref, orderBy('fecha', 'desc'));
    return collectionData(q, { idField: 'id' }) as Observable<Consulta[]>;
  }

  agregar(data: { motivo: string; diagnostico?: string; pacienteId: string }) {
    const consulta = {
      ...data,
      fecha: Timestamp.now(),
      medico: { id: 'med1', nombre: 'Dr. Ejemplo' },
      tipoConsulta: 'General',
      diagnosticos: [],
      ordenesMedicas: []
    };
    return addDoc(this.ref, consulta);
  }

  actualizar(id: string, data: Partial<Consulta>) {
    const consultaDoc = doc(this.firestore, `consultas/${id}`);
    return updateDoc(consultaDoc, data);
  }


  eliminar(id: string) {
    const consultaDoc = doc(this.firestore, `consultas/${id}`);
    return deleteDoc(consultaDoc);
  }
}