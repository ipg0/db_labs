drop view if exists employees_without_active_assignments;

create view employees_without_active_assignments as
  select
    employees.employee_id,
    employees.employee_name,
    employees.position
  from employees
  where not exists (
    select assignment_id
      from assignments
      where assignments.employee_id = employees.employee_id
        and assignments.actual_execution_date is null
    );