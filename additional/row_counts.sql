select count(*) as row_count, 'aircrafts' as table_name
from aircrafts_data
union
select count(*), 'airpoprts'
from airports_data
union
select count(*), 'boarding_passes'
from boarding_passes
union
select count(*), 'bookings'
from bookings
union
select count(*), 'flights'
from flights
union
select count(*), 'seats'
from seats
union
select count(*), 'ticket_flights'
from ticket_flights
union
select count(*), 'tickets'
from tickets;
