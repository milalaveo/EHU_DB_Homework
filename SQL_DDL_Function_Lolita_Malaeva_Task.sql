-- 1

DROP VIEW IF EXISTS sales_revenue_by_category_qtr;
CREATE VIEW sales_revenue_by_category_qtr AS
SELECT
    c.name AS category_name,
    SUM(p.amount) AS total_sales_revenue
FROM
    payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE
    EXTRACT(QUARTER FROM p.payment_date) = EXTRACT(QUARTER FROM CURRENT_DATE)
    AND EXTRACT(YEAR FROM p.payment_date) = EXTRACT(YEAR FROM CURRENT_DATE)
GROUP BY
    c.name
HAVING
    SUM(p.amount) > 0;

--2

CREATE OR REPLACE FUNCTION get_sales_revenue_by_category_qtr(quarter INTEGER) 
RETURNS TABLE(category_name VARCHAR, total_sales_revenue NUMERIC) AS $$
BEGIN
    RETURN QUERY
    SELECT
        c.name AS category_name,
        SUM(p.amount) AS total_sales_revenue
    FROM
        payment p
    JOIN rental r ON p.rental_id = r.rental_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    WHERE
        EXTRACT(QUARTER FROM p.payment_date) = quarter
        AND EXTRACT(YEAR FROM p.payment_date) = EXTRACT(YEAR FROM CURRENT_DATE)
    GROUP BY
        c.name
    HAVING
        SUM(p.amount) > 0;
END;
$$ LANGUAGE plpgsql;

--3

CREATE OR REPLACE FUNCTION new_movie(movie_title VARCHAR) RETURNS VOID AS $$
DECLARE
    lng_id INT;
BEGIN
    SELECT language_id INTO lng_id FROM language WHERE name = 'Klingon';
    IF NOT FOUND THEN
        INSERT INTO language (name) VALUES ('Klingon')
        RETURNING language_id INTO lng_id;
    END IF;

    INSERT INTO film(title, description, release_year, language_id, rental_duration, rental_rate, length, replacement_cost, rating)
    VALUES(movie_title, 'New Sci-Fi Movie', EXTRACT(YEAR FROM CURRENT_DATE), lng_id, 3, 4.99, 120, 19.99, 'PG');
END;
$$ LANGUAGE plpgsql;