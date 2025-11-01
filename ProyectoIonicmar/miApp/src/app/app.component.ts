import { Component } from '@angular/core';
import { Router, RouterLink } from '@angular/router';
import { addIcons } from 'ionicons';
import { personCircleOutline, documentTextOutline, logOutOutline, pencilOutline} from 'ionicons/icons';
import {
  IonApp,
  IonMenu,
  IonHeader,
  IonToolbar,
  IonTitle,
  IonContent,
  IonList,
  IonItem,
  IonIcon,
  IonLabel,
  IonRouterOutlet,
} from '@ionic/angular/standalone';

@Component({
  selector: 'app-root',
  templateUrl: 'app.component.html',
  styleUrls: ['app.component.scss'],
  standalone: true,
  imports: [
    IonApp,
    IonMenu,
    IonHeader,
    IonToolbar,
    IonTitle,
    IonContent,
    IonList,
    IonItem,
    IonIcon,
    IonLabel,
    IonRouterOutlet,
    RouterLink,
  ],
})
export class AppComponent {
  constructor(private router: Router) {
    addIcons({
      personCircleOutline,
      documentTextOutline,
      logOutOutline,
      pencilOutline
    });
  }

  cerrarSesion() {
    console.log('Cerrando sesión...');
    this.router.navigateByUrl('/login-paciente');
  }

}