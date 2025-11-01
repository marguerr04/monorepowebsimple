import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule } from '@angular/router';
import { IonContent, IonHeader, IonTitle, IonToolbar } from '@ionic/angular/standalone';

@Component({
  selector: 'app-nombrehome',
  templateUrl: './nombrehome.page.html',
  styleUrls: ['./nombrehome.page.scss'],
  standalone: true,
  imports: [IonContent, IonHeader, IonTitle, IonToolbar, RouterModule, CommonModule, FormsModule]
})
export class NombrehomePage implements OnInit {

  constructor() { }

  ngOnInit() {
  }

}
