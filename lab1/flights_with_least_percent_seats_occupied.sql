with aircraft_seats as (
	select distinct aircraft_code,
		count(seat_no) over (partition by aircraft_code) as total
	from seats
),
occupied_seats as (
	select distinct flight_id,
		count(ticket_flights.flight_id) over (partition by ticket_flights.flight_id) as occupied
	from ticket_flights
)
select flights.flight_no,
	flights.departure_airport,
	flights.arrival_airport,
	flights.scheduled_departure,
	flights.status,
	aircraft_seats.total as seats_total,
	occupied_seats.occupied as seats_occupied,
	round((occupied::numeric / total::numeric) * 100, 2) as percent_occupied
from occupied_seats
	join flights on flights.flight_id = occupied_seats.flight_id
	join aircraft_seats on aircraft_seats.aircraft_code = flights.aircraft_code
where status = 'Scheduled'
order by percent_occupied;