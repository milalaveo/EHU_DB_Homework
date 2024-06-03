INSERT INTO film (title, description, release_year, language_id, rental_duration, rental_rate, replacement_cost, rating)
VALUES ('Avengers', 'Mightiest heroes must come together to fight as a team.', 2012, 1, 14, 4.99, 19.99, 'PG-13');

INSERT INTO actor (first_name, last_name)
VALUES ('Robert', 'Downey Jr.'),
       ('Chris', 'Evans'),
       ('Scarlett', 'Johansson');

INSERT INTO film_actor (actor_id, film_id)
VALUES ((SELECT actor_id FROM actor WHERE first_name = 'Robert' AND last_name = 'Downey Jr.'), 1001),
       ((SELECT actor_id FROM actor WHERE first_name = 'Chris' AND last_name = 'Evans'), 1001),
       ((SELECT actor_id FROM actor WHERE first_name = 'Scarlett' AND last_name = 'Johansson'), 1001);

INSERT INTO inventory (film_id, store_id)
VALUES (1001, 1);
