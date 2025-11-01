import { Component, OnInit, Input, Output, EventEmitter } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { IonCard, IonCardContent, IonButton } from '@ionic/angular/standalone';

@Component({
  selector: 'app-bloque-contenido',
  templateUrl: './bloque-contenido.component.html',
  styleUrls: ['./bloque-contenido.component.scss'],
  standalone: true,
  imports: [ CommonModule, IonCard, RouterModule, IonCardContent, IonButton ]
})
export class BloqueContenidoComponent  implements OnInit {
  @Input() datos: { label: string; valor: string }[] = [];
  @Input() tituloSeccion?: string;
  @Input() botones: { texto: string; ruta: string; tipo?: string }[] = [];

  @Output() botonClic = new EventEmitter<string>();
  onBotonClick(ruta: string) {
    this.botonClic.emit(ruta);
  }


  constructor() { }
  ngOnInit() {}
}
