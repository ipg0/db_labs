select * from assignments, employees
  where expected_execution_date > now()
    and overdue_assignments > 10;

