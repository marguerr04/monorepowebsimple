import { ComponentFixture, TestBed } from '@angular/core/testing';
import { PaginaunoPage } from './paginauno.page';

describe('PaginaunoPage', () => {
  let component: PaginaunoPage;
  let fixture: ComponentFixture<PaginaunoPage>;

  beforeEach(() => {
    fixture = TestBed.createComponent(PaginaunoPage);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
