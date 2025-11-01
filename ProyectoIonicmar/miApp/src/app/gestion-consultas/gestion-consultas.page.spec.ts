import { ComponentFixture, TestBed } from '@angular/core/testing';
import { GestionConsultasPage } from './gestion-consultas.page';

describe('GestionConsultasPage', () => {
  let component: GestionConsultasPage;
  let fixture: ComponentFixture<GestionConsultasPage>;

  beforeEach(() => {
    fixture = TestBed.createComponent(GestionConsultasPage);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
