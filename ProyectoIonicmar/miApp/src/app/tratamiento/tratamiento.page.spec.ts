import { ComponentFixture, TestBed } from '@angular/core/testing';
import { TratamientoPage } from './tratamiento.page';

describe('TratamientoPage', () => {
  let component: TratamientoPage;
  let fixture: ComponentFixture<TratamientoPage>;

  beforeEach(() => {
    fixture = TestBed.createComponent(TratamientoPage);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
