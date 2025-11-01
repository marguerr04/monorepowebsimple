import { Component, Input } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';

import {
  IonCard,
  IonItem,
  IonButton,
  IonAvatar,
  IonIcon,
  IonLabel,
  IonCardTitle,
  IonCardSubtitle,
} from '@ionic/angular/standalone';

@Component({
  selector: 'app-card-content',
  templateUrl: './card-content.component.html',
  styleUrls: ['./card-content.component.scss'],
  standalone: true,
  imports: [
    CommonModule,
    RouterModule,
    IonCard,
    IonItem,
    IonButton,
    IonAvatar,
    IonIcon,
    IonLabel,
    IonCardTitle,
    IonCardSubtitle,
  ],
})
export class CardContentComponent {
  @Input() texto1: string = '';
  @Input() texto2: string = '';
  @Input() texto3: string = '';

  @Input() boton1: string = '';

  constructor() {}
}