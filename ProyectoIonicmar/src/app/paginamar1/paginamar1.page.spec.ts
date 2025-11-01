import { ComponentFixture, TestBed } from '@angular/core/testing';
import { Paginamar1Page } from './paginamar1.page';

describe('Paginamar1Page', () => {
  let component: Paginamar1Page;
  let fixture: ComponentFixture<Paginamar1Page>;

  beforeEach(() => {
    fixture = TestBed.createComponent(Paginamar1Page);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
