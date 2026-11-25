select full_name, preferred_warehouse_id
from volunteers
where preferred_warehouse_id is distinct from (
    select id
    from warehouses
    where name = 'North'
);


