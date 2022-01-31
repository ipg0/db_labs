alter table assignments
  add constraint fk_project
    foreign key (project_id)
      references projects(project_id) on delete cascade;
alter table assignments
  add constraint fk_employee
    foreign key (employee_id)
      references employees(employee_id);

alter table contracts
  add constraint fk_project
    foreign key (project_id)
      references projects(project_id) on delete cascade;
alter table contracts
  add constraint fk_contractor
    foreign key (contractor_id)
      references contractors(contractor_id);