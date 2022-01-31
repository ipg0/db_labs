select
  employees.employee_id,
  employees.employee_name,
  employees.position,
  count(completed.assignment_id) as completed_assignments
from employees
  left join assignments completed on completed.employee_id = employees.employee_id
                                  and completed.actual_execution_date is not null
  left join assignments overdue on overdue.actual_execution_date > overdue.expected_execution_date
group by employees.employee_id;