import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule } from '@angular/router';
import { IonContent, IonHeader, IonTitle, IonToolbar, IonItem, IonLabel, IonInput } from '@ionic/angular/standalone';

@Component({
  selector: 'app-login-medico',
  templateUrl: './login-medico.page.html',
  styleUrls: ['./login-medico.page.scss'],
  standalone: true,
  imports: [IonContent, IonHeader, IonTitle, IonToolbar, IonItem, IonLabel, IonInput, RouterModule, CommonModule, FormsModule]
})
export class LoginMedicoPage implements OnInit {

  constructor() { }

  ngOnInit() {
  }

}
