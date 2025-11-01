// En: src/app/core/models/ficha-medica.model.ts
// Este archivo contiene las interfaces optimizadas para una base de datos NoSQL como Firestore.
// Se aplica desnormalización y anidación para minimizar las lecturas y mejorar el rendimiento.
import { Injectable } from '@angular/core';
import {
  Firestore, collection, collectionData, addDoc,
  doc, deleteDoc, Timestamp, query, orderBy
} from '@angular/fire/firestore';
import { Observable } from 'rxjs';

// --- Interfaces de Datos Anidados (Sub-colecciones o arrays) ---
// Estos objetos no serán colecciones principales, sino que vivirán dentro de otros documentos.

export interface AlergiaAnidada {
  alergiaId: string; // ID del documento en la colección 'alergias'
  nombre: string;
  tipoAlergia: string;
  severidad: string;
}

export interface VacunaAnidada {
  vacunaId: string; // ID del documento en la colección 'vacunas'
  nombre: string;
  fecha: Timestamp;
}

export interface DiagnosticoAnidado {
  diagnosticoId: string; // ID del documento en la colección 'diagnosticos'
  nombre: string;
  esCronico: boolean;
}

export interface MedicamentoRecetado {
  medicamentoId: string; // ID del documento en la colección 'medicamentos'
  nombre: string;
  dosis?: string;
  frecuencia: string;
  esPermanente?: boolean;
}

export interface ResultadoAnalitoAnidado {
  // Ya no necesita ID propio, vive dentro de un Examen
  nombreAnalito: string;
  unidadMedida: string;
  dentroRango: boolean;
  resultadoText?: string;
  resultadoNum?: number;
  rangoReferencia: string; // Unimos inferior y superior para simplicidad
}


// --- Entidades Principales (Serán Colecciones en Firestore) ---

export interface Paciente {
  id?: string; // ID único generado por Firestore
  rut: number;
  dv: string;
  nombre: string;
  sexo: string;
  fechaNac: Timestamp;
  telefono: string;
  direccion: string;
  // Datos desnormalizados y anidados para evitar JOINs
  tipoSangre: string; // Se guarda el valor directamente
  alergias: AlergiaAnidada[]; // Array de objetos anidados
  vacunas: VacunaAnidada[]; // Array de objetos anidados
  habitos: string[]; // Un simple array de strings es suficiente
  condicionesCronicas: DiagnosticoAnidado[]; // Para acceso rápido en emergencias
}



/* Consulta compleja a implementar despues 
export interface Consulta {
  id?: string;
  pacienteId: string; // FK a la colección 'pacientes'
  fecha: Timestamp;
  pesoPaciente?: number;
  alturaPaciente?: number;
  consultaPdfUrl?: string;
  // Datos del médico desnormalizados
  medico: {
    id: string;
    nombre: string;
  };
  // Tipo de consulta desnormalizado
  tipoConsulta: string;
  // Diagnósticos y receta anidados dentro de la consulta
  diagnosticos: DiagnosticoAnidado[];
  receta?: MedicamentoRecetado[]; // La receta es un array de medicamentos
  ordenesMedicas?: {
      tipoOrden: string;
      indicaciones?: string;
  }[];
}
*/

export interface Consulta {
  id?: string;
  pacienteId: string;
  motivo: string; // Campo principal para el formulario
  diagnostico?: string; // Campo secundario opcional
  fecha: Timestamp;
  // Campos simplificados (con valores por defecto en el servicio)
  medico: {
    id: string;
    nombre: string;
  };
  tipoConsulta: string;
  diagnosticos: any[]; // Simplificado
  ordenesMedicas?: any[]; // Simplificado
}






export interface Examen {
  id?: string;
  pacienteId: string; // FK a la colección 'pacientes'
  fecha: Timestamp;
  estadoExamen: string;
  comentariosExamen?: string;
  rutaPdfUrl?: string;
  // Datos del examen y lugar desnormalizados
  tipoExamen: string;
  sucursal: {
    nombre: string;
    centroMedico: string;
  };
  // Los resultados de los analitos se anidan directamente en el examen
  resultados: ResultadoAnalitoAnidado[];
}

export interface Intervencion {
  id?: string;
  pacienteId: string; // FK a la colección 'pacientes'
  fecha: Timestamp;
  descripcion?: string;
  // Datos desnormalizados
  tipoIntervencion: string;
  sucursal: {
    nombre: string;
    centroMedico: string;
  };
}


// --- Entidades de Catálogo (Colecciones para llenar selects/dropdowns) ---
// Estas colecciones se leerían una vez para obtener las opciones disponibles en la UI.

export interface Alergia {
  id?: string;
  nombre: string;
  tipoAlergia: string;
}

export interface Diagnostico {
  id?: string;
  nombre: string;
  esCronico: boolean;
}

export interface Habito {
  id?: string;
  nombre: string;
}

export interface Medicamento {
  id?: string;
  nombre: string;
  tipoMedicamento: string;
}

export interface Severidad {
  id?: string;
  nombre: string; // Ej: 'Crítica', 'Severa', 'Moderada'
}

export interface Vacuna {
  id?: string;
  nombre: string;
}

