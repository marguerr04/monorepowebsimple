// En: src/main.ts
import { enableProdMode } from '@angular/core';
import { bootstrapApplication } from '@angular/platform-browser';
import { RouteReuseStrategy, provideRouter } from '@angular/router';
import { IonicRouteStrategy, provideIonicAngular } from '@ionic/angular/standalone';

// Importa las herramientas de Firebase (incluyendo enableIndexedDbPersistence)
import { initializeApp, provideFirebaseApp } from '@angular/fire/app';
import { provideFirestore, getFirestore, enableIndexedDbPersistence } from '@angular/fire/firestore';
import { environment } from './environments/environment';
import { provideHttpClient } from '@angular/common/http';

import { routes } from './app/app.routes';
import { AppComponent } from './app/app.component';

if (environment.production) {
  enableProdMode();
}

// Reemplaza tu bootstrapApplication con este
bootstrapApplication(AppComponent, {
  providers: [
    { provide: RouteReuseStrategy, useClass: IonicRouteStrategy },
    provideIonicAngular(),
    provideRouter(routes),

    provideHttpClient(),

    // Llama a los providers directamente, sin importProvidersFrom
    provideFirebaseApp(() => initializeApp(environment.firebase)),
    
    // Configura Firestore con la persistencia offline
    provideFirestore(() => {
      const db = getFirestore();
      try {
        enableIndexedDbPersistence(db);
      } catch (e) {
        console.error('Error al habilitar la persistencia offline:', e);
      }
      return db;
    }),
  ],
}).catch(err => console.error(err)); // Añade el manejo de errores al final