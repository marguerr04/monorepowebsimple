import { ComponentFixture, TestBed } from '@angular/core/testing';
import { PaginacincoPage } from './paginacinco.page';

describe('PaginacincoPage', () => {
  let component: PaginacincoPage;
  let fixture: ComponentFixture<PaginacincoPage>;

  beforeEach(() => {
    fixture = TestBed.createComponent(PaginacincoPage);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
