import { ComponentFixture, TestBed } from '@angular/core/testing';
import { NombrehomePage } from './nombrehome.page';

describe('NombrehomePage', () => {
  let component: NombrehomePage;
  let fixture: ComponentFixture<NombrehomePage>;

  beforeEach(() => {
    fixture = TestBed.createComponent(NombrehomePage);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
