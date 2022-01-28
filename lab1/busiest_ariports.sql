select airport_name,
	airport_code,
	count(flight_id) as total_flights
from airports,
	flights
where flights.arrival_airport = airports.airport_code
	or flights.departure_airport = airports.airport_code
group by airport_name,
	airport_code
order by total_flights desc;