-- Доля вины перевозчика среди исходных причин задержек и домино — по каждому перевозчику, за весь период.
-- считаю: вина перевозчика
-- делю на: исходные причины
-- сравниваю с: авиакомпаниями 

with origin_reasons as(
select d.carrier, sum(d.carrier_delay + d.nas_delay + d.security_delay + d.weather_delay) as origin_minutes
from delays d
group by d.carrier)
select d.carrier, d.carrier_name, 
sum(d.arr_flights) as flights_carrier, sum(d.carrier_delay) as carrier_minutes, origin_minutes, 
round((sum(d.late_aircraft_delay)/ origin_minutes),3) as domino,
round((sum(d.carrier_delay) * 100.0 / origin_minutes),2) as carrier_fault_share 
from delays d
	inner join origin_reasons
	on origin_reasons.carrier = d.carrier
group by d.carrier, d.carrier_name, origin_minutes
order by carrier_fault_share desc
