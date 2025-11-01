import { ComponentFixture, TestBed } from '@angular/core/testing';
import { NuevoexamenPage } from './nuevoexamen.page';

describe('NuevoexamenPage', () => {
  let component: NuevoexamenPage;
  let fixture: ComponentFixture<NuevoexamenPage>;

  beforeEach(() => {
    fixture = TestBed.createComponent(NuevoexamenPage);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
