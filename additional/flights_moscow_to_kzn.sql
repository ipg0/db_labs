-- with all_flights as (
  select
    departure_airport,
    -- null as transit_airport,
    arrival_airport,
    flight_no as first_flight,
    -- null as second_flight,
    -- null as transit_time,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
  from flights
  where (departure_airport = 'DME'
    or departure_airport = 'SVO'
    or departure_airport = 'VKO')
    and arrival_airport = 'KZN'
    and status = 'Arrived'
    and now() - actual_arrival <= interval '5 years'
--   union all select
--     f_first.departure_airport,
--     f_first.arrival_airport,
--     f_second.arrival_airport,
--     f_first.flight_no,
--     f_second.flight_no,
--     f_first.scheduled_arrival
--       - f_second.scheduled_departure as transit_time,
--     f_first.scheduled_departure,
--     f_second.scheduled_arrival,
--     f_first.actual_departure,
--     f_second.actual_arrival
--   from flights f_first
--     join flights f_second
--       on f_first.arrival_airport = f_second.departure_airport
--   where (f_first.departure_airport = 'DME'
--     or f_first.departure_airport = 'SVO'
--     or f_first.departure_airport = 'VKO')
--     and f_second.arrival_airport = 'UFA'
--     and f_first.status = 'Arrived'
--     and f_second.status = 'Arrived'
--     and f_first.scheduled_arrival
--       - f_second.scheduled_departure between
--       interval '-8 hours'
--       and interval '8 hours'
--     and now() - f_second.actual_arrival <= interval '5 years'
-- )
-- select
--   departure_airport,
--   a_from.airport_name as transit_airport_name,
--   transit_airport,
--   a_transit.airport_name as transit_airport_name,
--   arrival_airport,
--   a_to.airport_name as arrival_airport_name,
--   transit_time,
--   scheduled_departure,
--   scheduled_arrival,
--   actual_departure,
--   actual_arrival
-- from all_flights
--   join airports a_from
--     on a_from.airport_code = all_flights.departure_airport
--   join airports a_transit
--     on a_transit.airport_code = all_flights.transit_airport
--   join airports a_to
--     on a_to.airport_code = all_flights.arrival_airport