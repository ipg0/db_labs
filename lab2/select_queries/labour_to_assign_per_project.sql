select project_name,
  projects.project_id,
  projects.labour,
  greatest(
    projects.labour - coalesce(sum(assignments.labour), 0),
    0
  ) as labour_to_assign
from projects
  left join assignments
    on assignments.project_id = projects.project_id
group by projects.project_id
order by labour_to_assign desc;