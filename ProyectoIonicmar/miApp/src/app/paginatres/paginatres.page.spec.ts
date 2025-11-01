import { ComponentFixture, TestBed } from '@angular/core/testing';
import { PaginatresPage } from './paginatres.page';

describe('PaginatresPage', () => {
  let component: PaginatresPage;
  let fixture: ComponentFixture<PaginatresPage>;

  beforeEach(() => {
    fixture = TestBed.createComponent(PaginatresPage);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
