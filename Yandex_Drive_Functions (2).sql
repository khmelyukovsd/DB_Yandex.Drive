-- 5. скрипты характерных выборок (включающие группировки, JOIN'ы, вложенные таблицы)
-- 6. представления (минимум 2)
-- 7. хранимые процедуры / триггеры

-- Вывести все машины из категории Every_day
SELECT
     reg_number,
     status
FROM cars
WHERE car_models_id IN (SELECT id FROM car_models WHERE car_category_id = 1)
;

-- Вывести 5 самых часто ездящих пользователей
SELECT
       user_id,
       COUNT(user_id) AS Count_of_trips
FROM trips
GROUP BY user_id
ORDER BY COUNT(user_id) desc
LIMIT 5;

-- Вывести все чеки пользователя 10 за последний месяц
SELECT
       trip_id,
       cost,
       created_at
FROM receipts
WHERE trip_id IN (SELECT id FROM trips WHERE user_id = 10);

-- Вывести все маршруты авто №4
SELECT
       trip_id,
       start_lat,
       start_lng,
       finish_lat,
       finish_lng
FROM routes
WHERE trip_id IN (SELECT id FROM trips WHERE car_id = 4);

/*-- Вывести номер авто с ДТП > 2
SELECT *
FROM accidents
WHERE trip_id > 0;

SELECT
       car_id,
       COUNT(id) AS Count_of_trips
FROM trips
GROUP BY car_id
ORDER BY Count_of_trips desc
;
*/

-- Вывести пользователей моложе 1991 рождения, мужчин
SELECT
    firstname,
    lastname
FROM YandexDrive.users
WHERE id IN (
    SELECT user_id
    FROM profiles
    WHERE (gender = 'm') AND (birthday > '1999-01-01')
);

-- Вывести 5 авто с наибольшим количесвтом поездок
SELECT
       car_id,
       COUNT(id)
FROM trips
GROUP BY car_id
ORDER BY COUNT(id) desc
LIMIT 5;

-- Вывести все чеки с ценой > 400
SELECT
       cost
FROM receipts
WHERE cost > 400
ORDER BY cost desc;

-- Представления

-- Показать все цены на машины из категории holiday
CREATE OR REPLACE VIEW view_category_price AS
SELECT
    tt.name AS tariff_types,
    t.price AS price
FROM tariffs AS t
JOIN tariff_types AS tt
ON tt.id = t.tariff_types_id
WHERE t.car_category_id = 4
;

SELECT * FROM view_category_price;

-- Показать все модели машин из категории Every_day_plus
CREATE OR REPLACE VIEW view_category_model AS
SELECT
    m.mark AS car_mark,
    m.model AS car_models,
    c.name AS car_category
FROM car_category AS c
JOIN car_models AS m
ON c.id = m.car_category_id
WHERE c.name = 'every_day_plus'
;
SELECT * FROM view_category_model;

-- Транзакции
-- перевести машину в статус "занята"
UPDATE cars
SET `status` = 'busy'
WHERE id = 1;
