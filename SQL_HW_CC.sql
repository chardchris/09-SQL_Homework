use sakila;

select * from actor;

-- 1a.
select first_name, last_name 
from actor;

-- 1b.?
select upper(concat(first_name," ",last_name)) as 'Actor Name' 
from actor;

-- 2a. 
select actor_id, first_name, last_name 
from actor
where first_name = 'Joe';

-- 2b.
select * 
from actor
where last_name like '%gen%';

-- 2c.
select last_name, first_name 
from actor
where last_name like '%LI%';

-- 2d.
select country_id, country from country
where country in ('Afghanistan', 'Bangladesh', 'China');

-- 3a. 
ALTER TABLE actor
	ADD Description BLOB;
 
-- 3b.  
ALTER TABLE actor
	DROP COLUMN Description;

-- 4a. 
select last_name, count(last_name)
from actor
GROUP BY last_name;

-- 4b. 
select last_name, count(last_name)
from actor
GROUP BY last_name
HAVING count(last_name)>1;

-- 4c.
Update actor
Set first_name = 'HARPO'
Where first_name = 'GROUCHO' and last_name = 'WILLIAMS';

-- 4d. 
Update actor
Set first_name = 'GROUCHO'
Where first_name = 'HARPO';

-- 5a.
create table address;

-- 6a.
select staff.first_name, staff.last_name, address.address
from staff
JOIN address on staff.address_id=address.address_id;

-- 6b. 
select staff.first_name, staff.last_name, sum(payment.amount) as Total_August_Amount
from payment
JOIN staff on staff.staff_id=payment.staff_id
WHERE payment_date between '2005-08-01 00:00:00' and '2005-08-31 23:59:00'
Group by staff.first_name
;

-- 6c.
select film.title, count(film_actor.actor_id)
from film
	join film_actor on film_actor.film_id=film.film_id
Group by film.title;

-- 6d.
select count(inventory_id) from inventory
where film_id in
	(Select film_id
    from film
    where title = "Hunchback Impossible");

-- Validation of above subquery for 6d
select * from film where title = "Hunchback Impossible";
select * from inventory where film_id = 439;
    
-- 6e. 
select customer.first_name, customer.last_name, sum(payment.amount) as Total_Payment
from payment
	join customer on customer.customer_id = payment.customer_id
group by customer.first_name
order by customer.last_name asc;

-- 7a.
select * from film
where (title like 'Q%' or title like 'K%')
and language_id in (
	select language_id
    from language
    where name = "English");
    
-- 7b. 
Select * from actor
where actor_id in(
		select actor_id
        from film_actor
        where film_id in(
			select film_id from film
            where title = 'Alone Trip'
            )
		)
;

-- 7c. 
select * from customer
where address_id in(	
	select address_id from address
	where city_id in(
		select city_id from city
		where country_id in(
			select country_id from country
			where country = 'Canada')
            )
		);

select customer.first_name, customer.last_name, customer.email, country.country 
from customer
join address on address.address_id = customer.address_id
join city on city.city_id = address.city_id
join country on country.country_id = city.country_id
where country.country = 'Canada';

-- 7d.
select * from film
where film_id in(
	select film_id from film_category
    where category_id in(
		select category_id 
		from category
		where name='Family'
        )
	)
;

-- 7e. 
select film.title, count(rental.rental_date) as Number_of_Rentals
from rental
join inventory on inventory.inventory_id = rental.inventory_id
join film on film.film_id = inventory.film_id
group by film.title
order by Number_of_Rentals DESC;

-- 7f.
select * from payment;
select store.store_id, sum(payment.amount) as Total_Revenue
from store
join payment on payment.staff_id = store.manager_staff_id
group by store.store_id;

-- 7g.
select * from store;
select store.store_id, city.city, country.country
from store
join address on address.address_id = store.address_id
join city on city.city_id = address.city_id
join country on country.country_id = city.country_id;

-- 7h.
select category.name, sum(payment.amount) as Gross_Revenue
from payment
join rental on rental.rental_id = payment.rental_id
join inventory on inventory.inventory_id = rental.inventory_id
join film_category on film_category.film_id = inventory.film_id
join category on category.category_id = film_category.category_id
group by category.name
order by Gross_Revenue DESC
limit 5;

-- 8a. 
CREATE VIEW Top_5_Genres as
select category.name, sum(payment.amount) as Gross_Revenue
from payment
join rental on rental.rental_id = payment.rental_id
join inventory on inventory.inventory_id = rental.inventory_id
join film_category on film_category.film_id = inventory.film_id
join category on category.category_id = film_category.category_id
group by category.name
order by Gross_Revenue DESC
limit 5;

-- 8b.
select * from Top_5_Genres;

-- 8c.
DROP VIEW Top_5_Genres;
