--Вывести какие модели самолётов летают в Уфу

select fv.aircraft_code, model
from aircrafts a
         join flights_v fv on a.aircraft_code = fv.aircraft_code
where arrival_city = 'Уфа'
group by model, fv.aircraft_code;


--Среднее количество людей на рейсах из Санкт-Петербурга в Москву

select round(sum(passenger_count) / count(*)) as avg_tickets_MSK_to_SPB
from (select count(*) as passenger_count
      from tickets
               join ticket_flights tf on tickets.ticket_no = tf.ticket_no
               join flights_v fv on tf.flight_id = fv.flight_id
      where fv.departure_city = 'Санкт-Петербург'
        and fv.arrival_city = 'Москва'
        and actual_departure is not null
      group by fv.flight_id) as fnpc;


--Найти модель самолета с максимальным количеством сидений (учитывается что таких моделей может быть несколько)

select aircrafts_data.aircraft_code, model, max(seats) as seats
from (select a.aircraft_code, count(seat_no) as seats
      from aircrafts a
               join seats s on a.aircraft_code = s.aircraft_code
      group by a.aircraft_code, s.aircraft_code) as mcsn
         join aircrafts_data on mcsn.aircraft_code = aircrafts_data.aircraft_code
group by aircrafts_data.aircraft_code
order by seats desc
limit 1;



--Вывести рейсы число мест в которых больше чем проданных на них билетов

--count_seats
select a.aircraft_code, model, count(seat_no) as count_seats
from aircrafts a
         join seats s on a.aircraft_code = s.aircraft_code
group by model, a.aircraft_code
order by count_seats desc;

--sold_tickets
select f.flight_id, count(ticket_no) as sold_tickets
from ticket_flights
         join flights f on f.flight_id = ticket_flights.flight_id
group by f.flight_id;

--correlation

select flights.flight_id, count_seats.count_seats, sold_tickets.sold_tickets
from flights
         join (select a.aircraft_code, model, count(seat_no) as count_seats
               from aircrafts a
                        join seats s on a.aircraft_code = s.aircraft_code
               group by model, a.aircraft_code) as count_seats using (aircraft_code)
         join (select f.flight_id, count(ticket_no) as sold_tickets
               from ticket_flights
                        join flights f on f.flight_id = ticket_flights.flight_id
               group by f.flight_id) as sold_tickets using (flight_id);


--Вывести общую сумму потраченные на билеты каждым пассажиром

select passenger_id, /*json_agg(json_build_object(flight_id, amount)) as details,*/ sum(amount)
from tickets t
         left join ticket_flights as tf on t.ticket_no = tf.ticket_no
group by passenger_id;



--На каких местах сидел пассажир летающий чаще всего?
--v1
select tickets.passenger_id, array_agg(bp.seat_no) as seats, count(bp.flight_id) as flights
from tickets
         left join boarding_passes bp on tickets.ticket_no = bp.ticket_no
group by passenger_id
order by count(bp.flight_id) desc;

--v2
select *
from (select passenger_id as pid, seat_no, count(flight_id) over (partition by passenger_id) as flights
      from tickets tc
               left outer join boarding_passes bp on tc.ticket_no = bp.ticket_no) seats
where flights =
      (select max(flights)
       from (select count(flight_id) over (partition by passenger_id) as flights
             from tickets tc
                      left outer join boarding_passes bp on tc.ticket_no = bp.ticket_no) seats);



--Выведите таблицу самолетов отсортированных по убыванию количества мест с дополнительным атрибутом,
--в котором самолёты пронумерованы по частоте полётов.

select s.aircraft_code,
       count(distinct seat_no)   as seats,
       count(distinct flight_id) as flights
from seats s
         left join flights f on f.aircraft_code = s.aircraft_code
where status = 'Arrived'
group by s.aircraft_code
order by count(distinct seat_no) desc;

