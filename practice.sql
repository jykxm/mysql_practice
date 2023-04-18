select * from point_users
where point > 20000;

select * from users
where name = "황**";

select * from orders
where course_title = "웹개발 종합반" and payment_method = "CARD";

select * from orders
where course_title != "웹개발 종합반";

select * from orders
where created_at between "2020-07-13" and "2020-07-15";

select * from checkins 
where week in (1, 3);

select * from users 
where email like '%daum.net';

select * from orders 
where payment_method = "kakaopay"
limit 5;

select distinct(payment_method) from orders;

select count(*) from orders;

select name, count(*) from users
group by name
order by count(*) desc;

select name, count(*) as cnt_name from enrolleds e
inner join users u
on e.user_id = u.user_id 
where is_registered = 0
group by name
order by cnt_name desc;

select c1.title, c2.week, count(*) as cnt from courses c1
inner join checkins c2 on c1.course_id = c2.course_id
inner join orders o on c2.user_id = o.user_id
where o.created_at >= '2020-08-01'
group by c1.title, c2.week
order by c1.title, c2.week;

select count(point_user_id) as pnt_user_cnt,
       count(*) as tot_user_cnt,
       round(count(point_user_id)/count(*),2) as ratio
  from users u
  left join point_users pu on u.user_id = pu.user_id
 where u.created_at between '2020-07-10' and '2020-07-20';
 
 (
	select '7월' as month, c.title, c2.week, count(*) as cnt from checkins c2
	inner join courses c on c2.course_id = c.course_id
	inner join orders o on o.user_id = c2.user_id
	where o.created_at < '2020-08-01'
	group by c2.course_id, c2.week
  order by c2.course_id, c2.week
)
union all
(
	select '8월' as month, c.title, c2.week, count(*) as cnt from checkins c2
	inner join courses c on c2.course_id = c.course_id
	inner join orders o on o.user_id = c2.user_id
	where o.created_at >= '2020-08-01'
	group by c2.course_id, c2.week
  order by c2.course_id, c2.week
);

select c.title,
       a.cnt_checkins,
       b.cnt_total,
       (a.cnt_checkins/b.cnt_total) as ratio
from
(
	select course_id, count(distinct(user_id)) as cnt_checkins from checkins
	group by course_id
) a
inner join
(
	select course_id, count(*) as cnt_total from orders
	group by course_id 
) b on a.course_id = b.course_id
inner join courses c on a.course_id = c.course_id;

with table1 as (
	select course_id, count(distinct(user_id)) as cnt_checkins from checkins
	group by course_id
), table2 as (
	select course_id, count(*) as cnt_total from orders
	group by course_id
)
select c.title,
       a.cnt_checkins,
       b.cnt_total,
       (a.cnt_checkins/b.cnt_total) as ratio
from table1 a inner join table2 b on a.course_id = b.course_id
inner join courses c on a.course_id = c.course_id;

select user_id, email, SUBSTRING_INDEX(email, '@', -1) from users;

select substring(created_at,1,10) as date, count(*) as cnt_date from orders
group by date;

with table1 as (
	select enrolled_id, count(*) as done_cnt from enrolleds_detail
	where done = 1
	group by enrolled_id
), table2 as (
	select enrolled_id, count(*) as total_cnt from enrolleds_detail
	group by enrolled_id
)
select a.enrolled_id,
       a.done_cnt,
       b.total_cnt,
       round(a.done_cnt/b.total_cnt,2) as ratio
  from table1 a
 inner join table2 b on a.enrolled_id = b.enrolled_id;
