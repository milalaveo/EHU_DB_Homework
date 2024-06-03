DELETE FROM film_actor WHERE film_id IN (SELECT film_id FROM film WHERE title = 'Avengers');

DELETE FROM rental WHERE inventory_id IN (SELECT inventory_id FROM inventory WHERE film_id IN (SELECT film_id FROM film WHERE title = 'Avengers'));

DELETE FROM inventory WHERE film_id IN (SELECT film_id FROM film WHERE title = 'Avengers');

DELETE FROM film WHERE title = 'Avengers';

DELETE FROM payment WHERE customer_id IN (SELECT customer_id FROM customer WHERE first_name = 'Lolita' AND last_name = 'Malaeva');

DELETE FROM rental WHERE customer_id IN (SELECT customer_id FROM customer WHERE first_name = 'Lolita' AND last_name = 'Malaeva');
