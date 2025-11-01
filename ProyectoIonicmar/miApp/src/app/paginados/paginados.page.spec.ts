import { ComponentFixture, TestBed } from '@angular/core/testing';
import { PaginadosPage } from './paginados.page';

describe('PaginadosPage', () => {
  let component: PaginadosPage;
  let fixture: ComponentFixture<PaginadosPage>;

  beforeEach(() => {
    fixture = TestBed.createComponent(PaginadosPage);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
