drop trigger if exists fire_employee on employees;
drop function if exists fire_employee();

create function fire_employee()
returns trigger as $$
declare
  current_assignment_id integer;
  employees_total integer;
  ctr integer;
  new_employee record;
begin
  ctr := 0;
  raise notice 'Firing employee: %', old.employee_name;
  select count(*)
    into employees_total
    from employees;
  for current_assignment_id in
    (select ac.assignment_id
      from assignments ac
      where employee_id = old.employee_id)
    loop
      select *
        into new_employee
        from employees e
        where e.employee_id = mod(old.employee_id + ctr, employees_total - 1) + 1;
      ctr := ctr + 1;
      raise notice 'Reassigning assignment with ID % to employee %', current_assignment_id, new_employee.employee_name;
      update assignments a
        set employee_id = new_employee.employee_id
        where a.assignment_id = current_assignment_id;
    end loop;
    return old;
end;
$$ language plpgsql;

create trigger fire_employee
  before delete on employees
  for each row execute procedure fire_employee();