-- 1 
CREATE USER rentaluser WITH PASSWORD 'rentalpassword';
GRANT CONNECT ON DATABASE ehuhomework TO rentaluser;

--2
GRANT SELECT ON TABLE customer TO rentaluser;
--CHECK BY SELECTING ALL CUSTOMERS 
SELECT * FROM customer;

--3
CREATE ROLE rental;
GRANT rental TO rentaluser;

--4
GRANT INSERT, UPDATE ON TABLE rental TO rental;

-- New row added
INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id, last_update)
VALUES ('2024-01-01 00:00:00', 1, 1, '2024-01-02 00:00:00', 1, CURRENT_TIMESTAMP);

-- Update existing row
UPDATE rental
SET return_date = '2024-01-03 00:00:00'
WHERE rental_id = 1;

--5
REVOKE INSERT ON TABLE rental FROM rental;

--Failed to insert new rows into the "rental" table
INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id, last_update)
VALUES ('2024-01-01 00:00:00', 1, 1, '2024-01-02 00:00:00', 1, CURRENT_TIMESTAMP);

--6
DO $$
DECLARE 
    customer_rec RECORD;
    role_name TEXT;
    rental_view_name TEXT;
    payment_view_name TEXT;
BEGIN
    FOR customer_rec IN
        SELECT
            customer_id,
            first_name,
            last_name
        FROM
            customer
        WHERE
            customer_id IN (SELECT customer_id FROM payment)
            AND customer_id IN (SELECT customer_id FROM rental)
    LOOP
        role_name := 'client_' || customer_rec.first_name || '_' || customer_rec.last_name;

        EXECUTE 'CREATE ROLE ' || quote_ident(role_name) || ' WITH LOGIN PASSWORD ''password''';

        rental_view_name := 'rental_view_' || customer_rec.first_name || '_' || customer_rec.last_name;
        EXECUTE 'CREATE VIEW ' || quote_ident(rental_view_name) || ' AS ' || 
                'SELECT * FROM rental WHERE customer_id = ' || customer_rec.customer_id;

        payment_view_name := 'payment_view_' || customer_rec.first_name || '_' || customer_rec.last_name;
        EXECUTE 'CREATE VIEW ' || quote_ident(payment_view_name) || ' AS ' || 
                'SELECT * FROM payment WHERE customer_id = ' || customer_rec.customer_id;

        EXECUTE 'GRANT SELECT ON ' || quote_ident(rental_view_name) || ' TO ' || quote_ident(role_name);
        EXECUTE 'GRANT SELECT ON ' || quote_ident(payment_view_name) || ' TO ' || quote_ident(role_name);
    END LOOP;
END $$;