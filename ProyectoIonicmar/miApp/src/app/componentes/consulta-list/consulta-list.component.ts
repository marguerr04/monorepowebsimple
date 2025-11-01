import { Component, Input, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { IonicModule } from '@ionic/angular';

@Component({
  selector: 'app-consulta-list',
  standalone: true,
  imports: [CommonModule, IonicModule],
  templateUrl: './consulta-list.component.html',
  styleUrls: ['./consulta-list.component.scss'],
})
export class ConsultaListComponent  implements OnInit {
  @Input() titulo: string = '';
  @Input() consultas: { nombre: string; fecha: string }[] = [];

  ngOnInit() {}

}
