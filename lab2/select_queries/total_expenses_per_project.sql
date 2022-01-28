select project_name,
  projects.project_id,
  coalesce(sum(contracts.cost), 0) as total_expense
from projects
  left join contracts on contracts.project_id = projects.project_id
group by projects.project_id
order by total_expense desc;