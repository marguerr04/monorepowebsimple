import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class BackendService {
  private apiUrl = 'http://localhost:3000/api'; // cambiar esto para que apunte

  constructor(private http: HttpClient) {}

  testConnection(): Observable<any> {
    return this.http.get(`${this.apiUrl}`);
  }

  getPacientes(): Observable<any[]> {
    return this.http.get<any[]>(`${this.apiUrl}/pacientes`);
  }

  getConsultas(): Observable<any[]> {
    return this.http.get<any[]>(`${this.apiUrl}/consultas`);
  }

  getExamenes(): Observable<any[]> {
    return this.http.get<any[]>(`${this.apiUrl}/examenes`);
  }

  buscarPacientePorRUT(rut: string): Observable<any> {
    return this.http.get<any>(`${this.apiUrl}/pacientes/rut/${rut}`);
  }

  loginPaciente(rut: string, correo: string, clave: string): Observable<any> {
    return this.http.post(`${this.apiUrl}/pacientes/login`, {
      rut,
      correo, 
      clave
    });
  }

  obtenerPerfilPaciente(pacienteId: number): Observable<any> {
    return this.http.get<any>(`${this.apiUrl}/pacientes/${pacienteId}`);
  }

  getTipoSangre(id: number): Observable<any> {
    return this.http.get<any>(`${this.apiUrl}/tipo-sangre/${id}`);
  }

  getCentroMedico(id: number): Observable<any> {
    return this.http.get<any>(`${this.apiUrl}/centro-medico/${id}`);
  }

  getConsultasPorPaciente(pacienteId: number): Observable<any[]> {
    return this.http.get<any[]>(`${this.apiUrl}/pacientes/${pacienteId}/consultas`);
  }

  getExamenesPorPaciente(pacienteId: number): Observable<any[]> {
    return this.http.get<any[]>(`${this.apiUrl}/pacientes/${pacienteId}/examenes`);
  }

  getTiposExamen(): Observable<any[]> {
    return this.http.get<any[]>(`${this.apiUrl}/tipos-examen`);
  }

  getCentrosMedicos(): Observable<any[]> {
    return this.http.get<any[]>(`${this.apiUrl}/centros-medicos`);
  }
}
