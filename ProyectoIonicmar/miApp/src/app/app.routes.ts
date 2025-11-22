import { Routes } from '@angular/router';

export const routes: Routes = [
  {
    path: 'home',
    loadComponent: () => import('./home/home.page').then((m) => m.HomePage),
  },
  {
    path: '',
    redirectTo: 'login-paciente',
    pathMatch: 'full',
  },
  {
    path: 'nombrehome',
    loadComponent: () => import('./nombrehome/nombrehome.page').then( m => m.NombrehomePage)
  },
  {
    path: 'paginauno',
    loadComponent: () => import('./paginauno/paginauno.page').then( m => m.PaginaunoPage)
  },
  {
    path: 'paginados',
    loadComponent: () => import('./paginados/paginados.page').then( m => m.PaginadosPage)
  },
  {
    path: 'paginatres',
    loadComponent: () => import('./paginatres/paginatres.page').then( m => m.PaginatresPage)
  },
  {
    path: 'paginacuatro',
    loadComponent: () => import('./paginacuatro/paginacuatro.page').then( m => m.PaginacuatroPage)
  },
  {
    path: 'paginacinco',
    loadComponent: () => import('./paginacinco/paginacinco.page').then( m => m.PaginacincoPage)
  },
  {
    path: 'historial-paciente',
    loadComponent: () => import('./historial-paciente/historial-paciente.page').then( m => m.HistorialPacientePage)
  },
  {
    path: 'login-paciente',
    loadComponent: () => import('./login-paciente/login-paciente.page').then( m => m.LoginPacientePage)
  },
  {
    path: 'login-medico',
    loadComponent: () => import('./login-medico/login-medico.page').then( m => m.LoginMedicoPage)
  },

  { path: 'paginamar1', loadComponent: () => import('./paginamar1/paginamar1.page').then(m => m.Paginamar1Page) },
  { path: 'paginamar2', loadComponent: () => import('./paginamar2/paginamar2.page').then(m => m.Paginamar2Page) },
  { path: 'paginamar3', loadComponent: () => import('./paginamar3/paginamar3.page').then(m => m.Paginamar3Page) },
  { path: 'paginamar4', loadComponent: () => import('./paginamar4/paginamar4.page').then(m => m.Paginamar4Page) },
  { path: 'paginamar5', loadComponent: () => import('./paginamar5/paginamar5.page').then(m => m.Paginamar5Page) },
  { path: 'paginamar6', loadComponent: () => import('./paginamar6/paginamar6.page').then(m => m.Paginamar6Page) },
  {
    path: 'examenes',
    loadComponent: () => import('./examenes/examenes.page').then( m => m.ExamenesPage)
  },
  {
    path: 'nuevoexamen',
    loadComponent: () => import('./nuevoexamen/nuevoexamen.page').then( m => m.NuevoexamenPage)
  },
  {
    path: 'nuevaconsulta',
    loadComponent: () => import('./nuevaconsulta/nuevaconsulta.page').then( m => m.NuevaconsultaPage)
  },
  {
    path: 'gestion-consultas',
    loadComponent: () => import('./gestion-consultas/gestion-consultas.page').then( m => m.GestionConsultasPage)
  },  {
    path: 'datos-emergencia',
    loadComponent: () => import('./datos-emergencia/datos-emergencia.page').then( m => m.DatosEmergenciaPage)
  },
  {
    path: 'test-conexion',
    loadComponent: () => import('./test-conexion/test-conexion.page').then( m => m.TestConexionPage)
  },
  {
    path: 'tratamiento',
    loadComponent: () => import('./tratamiento/tratamiento.page').then( m => m.TratamientoPage)
  },

];


