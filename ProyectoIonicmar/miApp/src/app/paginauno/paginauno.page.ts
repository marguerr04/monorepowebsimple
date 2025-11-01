import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule } from '@angular/router';
import { IonContent, IonHeader, IonTitle, IonToolbar } from '@ionic/angular/standalone';

@Component({
  selector: 'app-paginauno',
  templateUrl: './paginauno.page.html',
  styleUrls: ['./paginauno.page.scss'],
  standalone: true,
  imports: [IonContent, IonHeader, IonTitle, IonToolbar, RouterModule, CommonModule, FormsModule]
})
export class PaginaunoPage implements OnInit {

  constructor() { }

  ngOnInit() {
  }

}
