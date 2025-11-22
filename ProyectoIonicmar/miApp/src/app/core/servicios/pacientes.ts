import { Injectable, inject } from '@angular/core';
import { 
  Firestore, 
  collection, 
  collectionData, 
  addDoc, 
  doc, 
  deleteDoc, 
  updateDoc,
  query,
  orderBy,
  Timestamp 
} from '@angular/fire/firestore';
import { Observable } from 'rxjs';
import { Paciente } from '../models/ficha-medica';

@Injectable({
  providedIn: 'root'
})

export class PacientesService {
  private firestore: Firestore = inject(Firestore);
  private pacientesCollection = collection(this.firestore, 'pacientes');

  constructor() { }

  getPacientes(): Observable<Paciente[]> {
    const q = query(this.pacientesCollection, orderBy('fechaNac', 'desc'));
    return collectionData(q, { idField: 'id' }) as Observable<Paciente[]>;
  }

  addPaciente(paciente: Paciente) {
    const { id, ...pacienteData } = paciente;
    return addDoc(this.pacientesCollection, pacienteData);
  }

  updatePaciente(id: string, paciente: Partial<Paciente>) {
    const pacienteDoc = doc(this.firestore, `pacientes/${id}`);
    return updateDoc(pacienteDoc, paciente);
  }

  deletePaciente(id: string) {
    const pacienteDoc = doc(this.firestore, `pacientes/${id}`);
    return deleteDoc(pacienteDoc);
  }
}