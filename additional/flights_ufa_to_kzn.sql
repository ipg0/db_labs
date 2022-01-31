with city_flights as (
  select *,
  a_city_from.city as departure_city,
  a_city_to.city as arrival_city
  from flights
    join airports a_city_from
      on a_city_from.airport_code = flights.departure_airport
    join airports a_city_to
      on a_city_to.airport_code = flights.arrival_airport
), all_flights as (
  select
    departure_airport,
    null as transit_arrival_airport,
    null as transit_departure_airport,
    arrival_airport,
    flight_no as first_flight,
    null as second_flight,
    null as transit_time,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
  from city_flights
  where departure_city = 'Уфа'
    and arrival_city = 'Казань'
    and status = 'Arrived'
    and now() - actual_arrival <= interval '5 years'
  union all select
    f_first.departure_airport,
    f_first.arrival_airport,
    f_second.departure_airport,
    f_second.arrival_airport,
    f_first.flight_no,
    f_second.flight_no,
    f_first.scheduled_arrival
      - f_second.scheduled_departure as transit_time,
    f_first.scheduled_departure,
    f_second.scheduled_arrival,
    f_first.actual_departure,
    f_second.actual_arrival
  from city_flights f_first
    join city_flights f_second
      on f_first.arrival_city = f_second.departure_city
  where f_first.departure_city = 'Уфа'
    and f_second.arrival_city = 'Казань'
    and f_first.status = 'Arrived'
    and f_second.status = 'Arrived'
    and f_first.scheduled_arrival
      - f_second.scheduled_departure between
      interval '-8 hours'
      and interval '8 hours'
    and now() - f_second.actual_arrival <= interval '5 years'
)
select
  departure_airport,
  a_from.airport_name as transit_airport_name,
  first_flight,
  transit_arrival_airport,
  a_transit_from.airport_name as transit_arrival_airport_name,
  transit_departure_airport,
  a_transit_to.airport_name as transit_departure_airport_name,
  second_flight,
  arrival_airport,
  a_to.airport_name as arrival_airport_name,
  transit_time,
  scheduled_departure,
  scheduled_arrival,
  actual_departure,
  actual_arrival
from all_flights
  join airports a_from
    on a_from.airport_code = all_flights.departure_airport
  join airports a_transit_from
    on a_transit_from.airport_code = all_flights.transit_arrival_airport
  join airports a_transit_to
    on a_transit_to.airport_code = all_flights.transit_departure_airport
  join airports a_to
    on a_to.airport_code = all_flights.arrival_airport;