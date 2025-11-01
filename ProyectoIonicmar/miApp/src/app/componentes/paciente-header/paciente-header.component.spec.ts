import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';

import { PacienteHeaderComponent } from './paciente-header.component';

describe('PacienteHeaderComponent', () => {
  let component: PacienteHeaderComponent;
  let fixture: ComponentFixture<PacienteHeaderComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      imports: [PacienteHeaderComponent],
    }).compileComponents();

    fixture = TestBed.createComponent(PacienteHeaderComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
