USE sakila;
-- Display first and last names of actors
SELECT first_name, last_name FROM actor;
-- Combine first and last names of actors in a single column
SELECT CONCAT(first_name, " ", last_name) AS actor_name FROM actor;
-- Select actors with a first name like "Joe"
SELECT actor_id, first_name, last_name FROM actor WHERE first_name LIKE 'Joe';
-- Select actor last names that have "gen" in them
SELECT last_name FROM actor WHERE last_name LIKE '%GEN%';
-- Select actor names where the last name contains "li"
SELECT last_name, first_name FROM actor WHERE last_name LIKE '%LI%';
-- Display country name and id where country is Afghanistan, Bangladesh and China
SELECT country_id, country FROM country WHERE country IN ('Afghanistan', 'Bangladesh', 'China');
-- Add a "blob" data type table to actor, named "description" 
ALTER TABLE actor
	ADD description BLOB;
-- remove description from actor table
ALTER TABLE actor
DROP description;
-- List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(*) AS duplicates
FROM actor
GROUP BY last_name
HAVING duplicates > 1;
-- find the name, Groucho Williams, and replace the first name with Harpo
SELECT first_name FROM actor WHERE first_name = 'Groucho' AND last_name = 'Williams';
-- reverse that back to "Harpo"
UPDATE actor
SET first_name = 'Harpo'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';
UPDATE actor
 SET first_name = 
 CASE 
 WHEN first_name = 'HARPO' 
 THEN 'GROUCHO'
 END
 WHERE actor_id = 172;
 -- show schema of the address table
SHOW CREATE TABLE sakila.address;
-- display the first and last names, as well as the address, of each staff member
SELECT * FROM staff;
SELECT * FROM address;
SELECT first_name, last_name, address
FROM staff s
INNER JOIN address a
ON s.address_id = a.address_id;
SELECT first_name, last_name, SUM(amount)
FROM staff s
INNER JOIN payment p
ON s.staff_id = p.staff_id
GROUP BY p.staff_id;
--  List each film and the number of actors who are listed for that film
SELECT title, COUNT(actor_id)
FROM film f
INNER JOIN film_actor fa
ON f.film_id = fa.film_id
GROUP BY title;
-- How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT title ,COUNT(inventory_id)
FROM film f
INNER JOIN inventory i
ON f.film_id = i.film_id
WHERE title = 'Hunchback Impossible';
-- list the total paid by each customer. List the customers alphabetically by last name:
SELECT first_name, last_name, SUM(amount)
FROM payment p
INNER JOIN customer c
ON p.customer_id = c.customer_id
GROUP BY p.customer_id
ORDER BY last_name ASC;
-- display the titles of movies starting with the letters K and Q whose language is English.
SELECT title 
FROM film 
WHERE (title LIKE 'K%') OR (title LIKE 'Q%') 
AND language_id IN 
	(SELECT language_id 
    FROM language 
    WHERE name = 'English');
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
	(SELECT actor_id FROM film_actor
	WHERE film_id in 
		(SELECT film_id FROM film
		WHERE title = "Alone Trip"));
-- names and email addresses of all Canadian customers.
SELECT country, last_name, first_name, email
FROM country c
LEFT JOIN customer cu
ON c.country_id = cu.customer_id
WHERE country = 'Canada';
-- movies categorized as family films.
SELECT film.title, film.film_id, category.name 
FROM film 
JOIN film_category 
ON film.film_id = film_category.film_id
JOIN category 
ON category.category_id = film_category.category_id
WHERE category.name = 'Family';
-- Display the most frequently rented movies in descending order.
SELECT inventory.inventory_id, film.title, count(rental.inventory_id) AS 'Rental Count' FROM rental 
JOIN inventory on inventory.inventory_id = rental.inventory_id
JOIN film on inventory.film_id = film.film_id
GROUP BY inventory.inventory_id
ORDER BY `Rental Count` DESC;
--   display how much business, in dollars, each store brought in. 
SELECT inventory.store_id, SUM(payment.amount)
FROM payment
JOIN inventory ON payment.rental_id = inventory.inventory_id
GROUP BY store_id;
-- display for each store its store ID, city, and country.
SELECT store.store_id, store.address_id, city.city, country.country
FROM store
JOIN address ON address.address_id = store.address_id
JOIN city ON city.city_id =  address.city_id
JOIN country ON country.country_id = city.country_id;
-- top five genres in gross revenue in descending order
SELECT category.name, SUM(payment.amount) as 'Total Revenue' FROM payment
JOIN rental on rental.rental_id = payment.rental_id
JOIN inventory on inventory.inventory_id = rental.inventory_id
JOIN film_category on film_category.film_id = inventory.film_id
JOIN category on category.category_id = film_category.category_id
GROUP BY category.name
ORDER BY SUM(payment.amount) DESC LIMIT 5;
-- create view for top 5 categories
CREATE VIEW top_5_categories as 
SELECT category.name, SUM(payment.amount) as 'Total Revenue' FROM payment
JOIN rental on rental.rental_id = payment.rental_id
JOIN inventory on inventory.inventory_id = rental.inventory_id
JOIN film_category on film_category.film_id = inventory.film_id
JOIN category on category.category_id = film_category.category_id
GROUP BY category.name
ORDER BY sum(payment.amount) DESC LIMIT 5;
-- Drop top_5_categories
DROP VIEW top_5_categories; 





