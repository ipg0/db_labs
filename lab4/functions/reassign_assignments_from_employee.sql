create or replace function reassign_assignments_from_employee(eid int)
returns refcursor as $$
declare
  current_assignment_id integer;
  employees_total integer;
  ctr integer;
  new_employee record;
  result cursor (_eid int) for
    select * from assignments where employee_id = eid;
begin
  ctr := 0;
  select count(*)
    into employees_total
    from employees;
  for current_assignment_id in
    (select ac.assignment_id
      from assignments ac
      where employee_id = eid)
    loop
      select *
        into new_employee
        from employees e
        where e.employee_id = mod(eid + ctr, employees_total - 1) + 1;
      ctr := ctr + 1;
      raise notice 'Reassigning assignment with ID % to employee %', current_assignment_id, new_employee.employee_name;
      update assignments a
        set employee_id = new_employee.employee_id
        where a.assignment_id = current_assignment_id;
    end loop;
  open result(eid);
  return result;
end;
$$ language plpgsql;
