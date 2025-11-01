import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule } from '@angular/router';
import { IonContent, IonHeader, IonTitle, IonToolbar } from '@ionic/angular/standalone';

@Component({
  selector: 'app-paginacuatro',
  templateUrl: './paginacuatro.page.html',
  styleUrls: ['./paginacuatro.page.scss'],
  standalone: true,
  imports: [IonContent, IonHeader, IonTitle, IonToolbar, RouterModule, CommonModule, FormsModule]
})
export class PaginacuatroPage implements OnInit {

  constructor() { }

  ngOnInit() {
  }

}
