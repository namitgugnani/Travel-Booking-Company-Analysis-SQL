-- creating a new database
create database travel_company ;

-- create the first table - booking_table
CREATE TABLE booking_table (
    Booking_id       VARCHAR(3) NOT NULL 
  , Booking_date     date NOT NULL
  , User_id          VARCHAR(2) NOT NULL
  , Line_of_business VARCHAR(6) NOT NULL
) ;


-- Inserting data in booking_table
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b1','2022-03-23','u1','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b2','2022-03-27','u2','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b3','2022-03-28','u1','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b4','2022-03-31','u4','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b5','2022-04-02','u1','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b6','2022-04-02','u2','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b7','2022-04-06','u5','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b8','2022-04-06','u6','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b9','2022-04-06','u2','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b10','2022-04-10','u1','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b11','2022-04-12','u4','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b12','2022-04-16','u1','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b13','2022-04-19','u2','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b14','2022-04-20','u5','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b15','2022-04-22','u6','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b16','2022-04-26','u4','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b17','2022-04-28','u2','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b18','2022-04-30','u1','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b19','2022-05-04','u4','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b20','2022-05-06','u1','Flight');

-- creating second table - user_table

CREATE TABLE user_table (
    User_id VARCHAR(3) NOT NULL
  , Segment VARCHAR(2) NOT NULL
);


-- Inserting data in booking_table
INSERT INTO user_table(User_id,Segment) VALUES ('u1','s1');
INSERT INTO user_table(User_id,Segment) VALUES ('u2','s1');
INSERT INTO user_table(User_id,Segment) VALUES ('u3','s1');
INSERT INTO user_table(User_id,Segment) VALUES ('u4','s2');
INSERT INTO user_table(User_id,Segment) VALUES ('u5','s2');
INSERT INTO user_table(User_id,Segment) VALUES ('u6','s3');
INSERT INTO user_table(User_id,Segment) VALUES ('u7','s3');
INSERT INTO user_table(User_id,Segment) VALUES ('u8','s3');
INSERT INTO user_table(User_id,Segment) VALUES ('u9','s3');
INSERT INTO user_table(User_id,Segment) VALUES ('u10','s3');


-- creating a segment level summary - users in each segment and users who booked flight ticket in April 2022 segment wise
select segment , count(distinct ut.user_id) as Total_user_count  , count(distinct case when month(booking_date) = '4' and
line_of_business = 'Flight' and year(booking_date) = '2022' then bt.user_id end)  as users_who_booked_flight_in_april_2022 from booking_table bt right join user_table ut
on ut.user_id = bt.user_id
group by segment ;


-- Finding User(s) who's first booking was of Hotel

select user_id from
(select * , rank() OVER(PARTITION BY user_id order by booking_date asc , booking_id asc) as rn from booking_table) yo 
where rn =1 and line_of_business='Hotel' ;

-- days between first booking and last booking of each user
select user_id , min(booking_date) as first_date , max(booking_date) as last_date , datediff(max(booking_date)  , min(booking_date)) as days_difference from booking_table
group by user_id ;

--  Count the number of flight and hotel booking in each segment in the year 2022

select segment , sum(case when line_of_business='Hotel' then 1 else 0 end) as Hotel_Booking_Count ,
sum(case when line_of_business='Flight' then 1 else 0 end) as Flight_Booking_Count
from booking_table bt right join user_table ut
on ut.user_id = bt.user_id 
where year(booking_date) = '2022' 
group by segment;
