drop table if exists contracts;
drop table if exists contractors;
drop table if exists assignments;
drop table if exists employees;
drop table if exists projects;

create table projects (
  project_id int primary key not null
    generated always as identity,
  project_name varchar not null,
  deadline date not null,
  labour int not null check (labour >= 0),
  contracts json not null
);

create table employees (
  employee_id int primary key not null
    generated always as identity,
  employee_name varchar not null,
  position varchar not null,
  overdue_assignments int not null
);

create table assignments (
  assignment_id int primary key not null
    generated always as identity,
  project_id int not null,
  employee_id int not null,
  issue_date date not null,
  labour int not null check (labour >= 0),
  expected_execution_date date,
  actual_execution_date date,
  constraint fk_project
    foreign key (project_id)
      references projects(project_id) on delete cascade,
  constraint fk_employee
    foreign key (employee_id)
      references employees(employee_id)
);

create table contractors (
  contractor_id int primary key not null
    generated always as identity,
  contractor_name varchar not null,
  contact_info varchar not null,
  projects int[]
);

create table contracts (
  contract_id int primary key not null
    generated always as identity,
  item varchar not null,
  execution_date date not null,
  cost float not null check (cost >= 0),
  contractor_id int not null,
  project_id int not null,
  constraint fk_project
    foreign key (project_id)
      references projects(project_id) on delete cascade,
  constraint fk_contractor
    foreign key (contractor_id)
      references contractors(contractor_id)
);
