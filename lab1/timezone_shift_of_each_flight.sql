select flights.flight_no,
  a_from.airport_name as departure_airport,
  a_to.airport_name as arrival_airport,
  tz_from.name as departure_timezone,
  tz_to.name as arrival_timezone,
  to_char(tz_from.utc_offset - tz_to.utc_offset, 'HH24:MI') as timezone_shift
from flights
  join airports a_from on flights.departure_airport = a_from.airport_code
  join airports a_to on flights.arrival_airport = a_to.airport_code
  join pg_timezone_names tz_from on a_from.timezone = tz_from.name
  join pg_timezone_names tz_to on a_to.timezone = tz_to.name
group by flights.flight_no,
  a_from.airport_name,
  a_to.airport_name,
  tz_from.utc_offset,
  tz_to.utc_offset,
  tz_from.name,
  tz_to.name
order by abs(extract(hours from tz_from.utc_offset - tz_to.utc_offset)) desc;