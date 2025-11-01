import { ComponentFixture, TestBed } from '@angular/core/testing';
import { TestConexionPage } from './test-conexion.page';

describe('TestConexionPage', () => {
  let component: TestConexionPage;
  let fixture: ComponentFixture<TestConexionPage>;

  beforeEach(() => {
    fixture = TestBed.createComponent(TestConexionPage);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
