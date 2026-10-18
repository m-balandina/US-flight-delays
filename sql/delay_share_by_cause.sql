-- считаю: Доля минут по пяти причинам за весь период.
-- делю на: общее время задержки
-- сравниваю с: 100%

with reasons_delay as(
select 
  sum(d.carrier_delay) as carrier, 
  sum(d.late_aircraft_delay) as late, 
  sum(d.nas_delay) as NAS, 
  sum(d.security_delay) as secure,
  sum(d.weather_delay) as weather,
(select sum(d1.carrier_delay + d1.late_aircraft_delay + d1.nas_delay + d1.security_delay + d1.weather_delay) 
  from delays d1) as total 
  from delays d)
select 'Вина перевозчика' as reason, round((carrier * 100.0/ total),2) as percentage from reasons_delay
union all
select 'Позднее прибытие ВС' as reason, round((late * 100.0/ total),2) as percentage from reasons_delay
union all
select 'Система УВД' as reason, round((NAS * 100.0/ total),2) as percentage from reasons_delay
union all
select 'Служба авиабезопасности' as reason, round((secure * 100.0/ total),2) as percentage from reasons_delay
union all
select 'Погодные условия' as reason, round((weather * 100.0/ total),2) as percentage from reasons_delay
order by percentage desc
