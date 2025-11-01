import { Component, Input } from '@angular/core';
import { CommonModule } from '@angular/common';

import {
  IonCard,
  IonItem,
  IonAvatar,
  IonIcon,
  IonLabel,
  IonCardTitle,
  IonCardSubtitle,
} from '@ionic/angular/standalone';

@Component({
  selector: 'app-paciente-header',
  templateUrl: './paciente-header.component.html',
  styleUrls: ['./paciente-header.component.scss'],
  standalone: true,
  imports: [
    CommonModule,
    IonCard,
    IonItem,
    IonAvatar,
    IonIcon,
    IonLabel,
    IonCardTitle,
    IonCardSubtitle,
  ],
})
export class PacienteHeaderComponent {
  @Input() titulo: string = '';
  @Input() subtitulo: string = '';
  @Input() subtitulo2: string = '';

  constructor() {}
}