select distinct flights.flight_no,
	a_from.airport_name as departure,
	a_to.airport_name as arrival,
	flights.scheduled_departure,
	flights.scheduled_arrival,
	sum(ticket_flights.amount) over (partition by ticket_flights.flight_id) as total_revenue
from ticket_flights
	join flights on flights.flight_id = ticket_flights.flight_id
	join airports a_from on flights.departure_airport = a_from.airport_code
	join airports a_to on flights.arrival_airport = a_to.airport_code
order by total_revenue desc;