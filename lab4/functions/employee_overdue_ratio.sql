create or replace function employee_overdue_ratio(eid int, percentage boolean default false)
returns float as $$
declare
  completed int;
  overdue int;
  ratio float;
begin
  select count(*)
    from assignments
    where employee_id = eid
      and actual_execution_date is not null
    into completed;
  select count(*)
    from assignments
    where employee_id = eid
      and actual_execution_date > expected_execution_date
    into overdue;
  ratio = overdue::float / completed::float;
  if percentage then
    return 100 * ratio;
  else
    return ratio;
  end if;
exception
  when division_by_zero then
    return 0;
end;
$$ language plpgsql;