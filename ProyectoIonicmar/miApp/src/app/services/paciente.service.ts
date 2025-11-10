import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface Alergia {
  id: number;
  nombre: string;
  tipo: string;
  severidad?: string;
}

export interface Diagnostico {
  id: number;
  nombre: string;
}

export interface TipoSangre {
  tiposangre: string;
}

@Injectable({
  providedIn: 'root'
})
export class PacienteService {
  private apiUrl = 'http://localhost:3000/api';

  constructor(private http: HttpClient) { }

  getPacienteById(pacienteId: number): Observable<any> {
    return this.http.get<any>(`${this.apiUrl}/pacientes/${pacienteId}`);
  }

  getAlergiasByPacienteId(pacienteId: number): Observable<Alergia[]> {
    return this.http.get<Alergia[]>(`${this.apiUrl}/pacientes/${pacienteId}/alergias`);
  }

  getDiagnosticosByPacienteId(pacienteId: number): Observable<Diagnostico[]> {
    return this.http.get<Diagnostico[]>(`${this.apiUrl}/pacientes/${pacienteId}/diagnosticos`);
  }

  getTipoSangreByPacienteId(pacienteId: number): Observable<TipoSangre> {
    return this.http.get<TipoSangre>(`${this.apiUrl}/pacientes/${pacienteId}/tipo-sangre`);
  }
}