import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class DatabaseService {
  private apiUrl = 'http://localhost:3000/api';

  constructor(private http: HttpClient) { }

  getConsultas(): Observable<any[]> {
    return this.http.get<any[]>(`${this.apiUrl}/consultas`);
  }

  getExamenes(): Observable<any[]> {
    return this.http.get<any[]>(`${this.apiUrl}/examenes`);
  }

  getPacientes(): Observable<any[]> {
    return this.http.get<any[]>(`${this.apiUrl}/pacientes`);
  }
}