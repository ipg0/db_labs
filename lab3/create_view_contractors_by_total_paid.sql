drop view if exists contractors_by_total_paid;

create view contractors_by_total_paid as
  select
    contractor_name,
    contractors.contractor_id,
    contact_info,
    coalesce(sum(cost), 0) as total_paid
  from
    contractors
    join contracts on contracts.contractor_id = contractors.contractor_id
  group by contractors.contractor_id
  order by total_paid desc;