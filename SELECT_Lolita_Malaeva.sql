-- solution 1 for task 1
SELECT staff.staff_id, staff.store_id, SUM(payment.amount) AS total_revenue
FROM payment
JOIN staff ON payment.staff_id = staff.staff_id
WHERE EXTRACT(YEAR FROM payment.payment_date) = 2017
GROUP BY staff.store_id, staff.staff_id
HAVING SUM(payment.amount) = (
    SELECT MAX(total_revenue)
    FROM (
        SELECT staff.store_id, SUM(payment.amount) AS total_revenue
        FROM payment
        JOIN staff ON payment.staff_id = staff.staff_id
        WHERE EXTRACT(YEAR FROM payment.payment_date) = 2017
        GROUP BY staff.store_id, staff.staff_id
    ) AS revenues_per_store
    WHERE revenues_per_store.store_id = staff.store_id
)
ORDER BY staff.store_id, total_revenue DESC;

-- solution 2 for task 1
WITH revenue_per_staff AS (
    SELECT staff.staff_id, staff.store_id, SUM(payment.amount) AS total_revenue
    FROM payment
    JOIN staff ON payment.staff_id = staff.staff_id
    WHERE EXTRACT(YEAR FROM payment.payment_date) = 2007
    GROUP BY staff.store_id, staff.staff_id
),
max_revenue_per_store AS (
    SELECT store_id, MAX(total_revenue) AS max_revenue
    FROM revenue_per_staff
    GROUP BY store_id
)
SELECT r.staff_id, r.store_id, r.total_revenue
FROM revenue_per_staff r
JOIN max_revenue_per_store m
ON r.store_id = m.store_id AND r.total_revenue = m.max_revenue
ORDER BY r.store_id, r.total_revenue DESC;

-- solution 1 for task 2
SELECT i.film_id, f.title, COUNT(*) AS rental_count
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
GROUP BY i.film_id, f.title
ORDER BY rental_count DESC
LIMIT 5;

-- expected age
WITH top_movies AS (
    SELECT i.film_id, f.title, f.rating, COUNT(*) AS rental_count
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    GROUP BY i.film_id, f.title, f.rating
    ORDER BY rental_count DESC
    LIMIT 5
)
SELECT tm.film_id, tm.title, tm.rating, tm.rental_count,
       CASE tm.rating
           WHEN 'G' THEN 'All ages'
           WHEN 'PG' THEN '8+'
           WHEN 'PG-13' THEN '13+'
           WHEN 'R' THEN '17+'
           WHEN 'NC-17' THEN '18+'
           ELSE 'Unknown'
       END AS expected_age
FROM top_movies tm;

-- solution 2 for task 2
SELECT top_movies.film_id, top_movies.title, top_movies.rental_count, f.rating,
       CASE f.rating
           WHEN 'G' THEN 'All ages'
           WHEN 'PG' THEN '8+'
           WHEN 'PG-13' THEN '13+'
           WHEN 'R' THEN '17+'
           WHEN 'NC-17' THEN '18+'
           ELSE 'Unknown'
       END AS expected_age
FROM (
    SELECT i.film_id, f.title, COUNT(*) AS rental_count
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    GROUP BY i.film_id, f.title
    ORDER BY rental_count DESC
    LIMIT 5
) AS top_movies
JOIN film f ON top_movies.film_id = f.film_id;

-- solution 1 for task 3
SELECT actor_id, NOW() - last_acting_date AS inactivity_period
FROM (
    SELECT fa.actor_id, MAX(r.rental_date) AS last_acting_date
    FROM film_actor fa
    JOIN inventory i ON fa.film_id = i.film_id
    JOIN rental r ON i.inventory_id = r.inventory_id
    GROUP BY fa.actor_id
) AS last_acting_dates
ORDER BY inactivity_period DESC;

-- solution 2 for task 3
WITH last_acting_dates AS (
    SELECT fa.actor_id, MAX(r.rental_date) AS last_acting_date
    FROM film_actor fa
    JOIN inventory i ON fa.film_id = i.film_id
    JOIN rental r ON i.inventory_id = r.inventory_id
    GROUP BY fa.actor_id
)
SELECT actor_id, NOW() - last_acting_date AS inactivity_period
FROM last_acting_dates
ORDER BY inactivity_period DESC;
