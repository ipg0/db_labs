drop trigger if exists unfinished_contract_deletion on contracts;
drop function if exists unfinished_contract_deletion();

create function unfinished_contract_deletion()
returns trigger as $$
declare
  contractor record;
begin
  if old.execution_date > now() then
    select *
    into contractor
    from contractors
    where contractor_id = old.contractor_id;
    raise exception 'Cannot delete unfinished contract with % for % due % with ID %',
      contractor.contractor_name, old.item, old.execution_date, old.contract_id;
  end if;
end;
$$ language plpgsql;

create trigger unfinished_contract_deletion
  before delete on contracts
  for each row execute procedure unfinished_contract_deletion();