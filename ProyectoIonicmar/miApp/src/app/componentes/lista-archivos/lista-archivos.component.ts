import { Component, Input, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { IonicModule } from '@ionic/angular';
import { RouterModule } from '@angular/router';

@Component({
  selector: 'app-lista-archivos',
  standalone: true,
  imports: [CommonModule, IonicModule, RouterModule],
  templateUrl: './lista-archivos.component.html',
  styleUrls: ['./lista-archivos.component.scss'],
})
export class ListaArchivosComponent  implements OnInit {
  @Input() titulo: string = '';
  @Input() consultas: { nombre: string; fecha: string | Date }[] = [];
  @Input() examenes: { nombre: string; fecha: string | Date }[] = [];

  @Input() warning: string = '';
  @Input() botones: { texto: string; ruta: string; tipo?: string }[] = [];

  constructor() { }
  ngOnInit() {}
}
