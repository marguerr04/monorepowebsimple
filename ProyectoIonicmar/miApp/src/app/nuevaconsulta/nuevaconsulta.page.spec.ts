import { ComponentFixture, TestBed } from '@angular/core/testing';
import { NuevaconsultaPage } from './nuevaconsulta.page';

describe('NuevaconsultaPage', () => {
  let component: NuevaconsultaPage;
  let fixture: ComponentFixture<NuevaconsultaPage>;

  beforeEach(() => {
    fixture = TestBed.createComponent(NuevaconsultaPage);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
