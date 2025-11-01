import { Routes } from '@angular/router';

export const routes: Routes = [
  {
    path: 'home',
    loadComponent: () => import('./home/home.page').then((m) => m.HomePage),
  },
  {
    path: '',
    redirectTo: 'home',
    pathMatch: 'full',
  },
  { path: 'paginamar1', loadComponent: () => import('./paginamar1/paginamar1.page').then(m => m.Paginamar1Page) },
  { path: 'paginamar2', loadComponent: () => import('./paginamar2/paginamar2.page').then(m => m.Paginamar2Page) },
  { path: 'paginamar3', loadComponent: () => import('./paginamar3/paginamar3.page').then(m => m.Paginamar3Page) },
  { path: 'paginamar4', loadComponent: () => import('./paginamar4/paginamar4.page').then(m => m.Paginamar4Page) },
  { path: 'paginamar5', loadComponent: () => import('./paginamar5/paginamar5.page').then(m => m.Paginamar5Page) },
  { path: 'paginamar6', loadComponent: () => import('./paginamar6/paginamar6.page').then(m => m.Paginamar6Page) },
];
