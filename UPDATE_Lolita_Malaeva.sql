UPDATE film
SET rental_duration = 21, rental_rate = 9.99
WHERE title = 'Avengers';

UPDATE customer
SET first_name = 'Lolita', last_name = 'Malaeva', email = 'lolita.malaeval@example.com', address_id = (SELECT address_id FROM address WHERE address = '786 Aurora Avenue')
WHERE customer_id = (
    SELECT customer_id
    FROM rental
    GROUP BY customer_id
    HAVING COUNT(*) >= 10
    INTERSECT
    SELECT customer_id
    FROM payment
    GROUP BY customer_id
    HAVING COUNT(*) >= 10
    LIMIT 1
);

UPDATE customer
SET create_date = current_date
WHERE first_name = 'Lolita' AND last_name = 'Malaeva';
