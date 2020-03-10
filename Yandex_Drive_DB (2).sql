/* Данная база данных предназначена для создания структуры хранения и обработки данных, необходимых
при работе каршеринга Яндекс.Драйв. В базе данных реализованы следующие сущности:
- Пользователи
- Профили
- Автомобили
- Поездки
- Тарифы
- Местоположение автомобилей?
- Стоимость
- Категории автомобилей
- Города
- 
*/

DROP DATABASE IF EXISTS YandexDrive;
CREATE DATABASE YandexDrive;
-- CHARSET = 'windows-1251';
-- COLLATE = 'windows-1251';
USE YandexDrive;

/*set character_set_database = 'cp1251';
set character_set_server = 'cp1251';
set character_set_system = 'cp1251';
SHOW VARIABLES LIKE 'char%';
*/

-- Создание таблицы "Пользователи"
DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id SERIAL PRIMARY KEY,
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    email VARCHAR(120) UNIQUE,
    phone BIGINT,
    INDEX users_phone_idx(phone),
    INDEX users_firstname_lastname_idx(firstname, lastname)
);

-- Создание таблицы "Профили"
DROP TABLE IF EXISTS profiles;
CREATE TABLE profiles (
    user_id SERIAL PRIMARY KEY,
    gender CHAR(1),
    birthday DATE,
	photo_id BIGINT UNSIGNED NULL,
    created_at DATE,
        -- DATETIME DEFAULT NOW(),
    driver_license BIGINT,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Создание таблицы "Типы медиафайлов"
DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types(
	id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    created_at DATETIME DEFAULT NOW()
);

-- Создание таблицы "Медиафайлы"
DROP TABLE IF EXISTS media;
CREATE TABLE media(
	id SERIAL PRIMARY KEY,
    media_type_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
  	body text,
    filename VARCHAR(255),
    `size` INT,
	metadata JSON,
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	
    INDEX (user_id),
   FOREIGN KEY (user_id) REFERENCES users(id),
   FOREIGN KEY (media_type_id) REFERENCES media_types(id)
);

-- Создание таблицы "Типы тарифов"
DROP TABLE IF EXISTS tariff_types;
CREATE TABLE tariff_types(
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    created_at DATETIME DEFAULT NOW()
);

-- Создание таблицы "Категории машин"
DROP TABLE IF EXISTS car_category;
CREATE TABLE car_category(
    id SERIAL PRIMARY KEY,
    name VARCHAR(20),
    created_at DATETIME DEFAULT NOW()
);

-- Создание таблицы "Тарифы"
DROP TABLE IF EXISTS tariffs;
CREATE TABLE tariffs(
    id SERIAL PRIMARY KEY,
    car_category_id BIGINT UNSIGNED NOT NULL,
    tariff_types_id BIGINT UNSIGNED NOT NULL,
    price BIGINT UNSIGNED NOT NULL,
    
    FOREIGN KEY (tariff_types_id) REFERENCES tariff_types(id),
    FOREIGN KEY (car_category_id) REFERENCES car_category(id)
);


-- Создание таблицы "Модели машин"
DROP TABLE IF EXISTS car_models;
CREATE TABLE car_models(
    id SERIAL PRIMARY KEY,
    mark VARCHAR(20),
    model VARCHAR(20),
    car_category_id BIGINT UNSIGNED NOT NULL,
    
    INDEX (model),
    FOREIGN KEY (car_category_id) REFERENCES car_category(id)
);

-- Создание таблицы "Машины"
DROP TABLE IF EXISTS cars;
CREATE TABLE cars(
    id SERIAL PRIMARY KEY,
    reg_number VARCHAR(20) UNIQUE,
    car_models_id BIGINT UNSIGNED NOT NULL,
    `status` ENUM ('free', 'busy', 'service'),
    fuel BIGINT UNSIGNED,
    location_lat FLOAT(12, 10) NOT NULL,
    location_lng FLOAT(12, 10) NOT NULL,
    
    INDEX (reg_number),
    FOREIGN KEY (car_models_id) REFERENCES car_models(id)
);

-- Создание таблицы "Осмотры машин"
DROP TABLE IF EXISTS inspections;
CREATE TABLE inspections(
    id SERIAL PRIMARY KEY,
    car_id BIGINT UNSIGNED NOT NULL,
    media_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT NOW(),
    discription TEXT,
    
    FOREIGN KEY (car_id) REFERENCES cars(id),
    FOREIGN KEY (media_id) REFERENCES media(id)
);

-- Создание таблицы "Поездки"
DROP TABLE IF EXISTS trips;
CREATE TABLE trips(
    id SERIAL PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    car_id BIGINT UNSIGNED NOT NULL,
    started_at DATETIME DEFAULT NOW(),
    -- finished_at DATETIME,
    
    INDEX (user_id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (car_id) REFERENCES cars(id)
);

-- Создание таблицы "Квитанции"
DROP TABLE IF EXISTS receipts;
CREATE TABLE receipts(
    id SERIAL PRIMARY KEY,
    trip_id BIGINT UNSIGNED NOT NULL,
    cost BIGINT UNSIGNED,
    created_at DATETIME,
    
    INDEX (trip_id),
    FOREIGN KEY (trip_id) REFERENCES trips(id)
    -- FOREIGN KEY (created_at) REFERENCES trips(started_at)
);

-- Создание таблицы "Маршруты"
DROP TABLE IF EXISTS routes;
CREATE TABLE routes(
    id SERIAL PRIMARY KEY,
    trip_id BIGINT UNSIGNED NOT NULL,
    start_lat FLOAT(12, 10) NOT NULL,
    start_lng FLOAT(12, 10) NOT NULL,
    finish_lat FLOAT(12, 10) NOT NULL,
    finish_lng FLOAT(12, 10) NOT NULL,

    INDEX (trip_id),
    FOREIGN KEY (trip_id) REFERENCES trips(id)
);

-- Создание таблицы "ДТП"
DROP TABLE IF EXISTS accidents;
CREATE TABLE accidents(
    id SERIAL PRIMARY KEY,
    trip_id BIGINT UNSIGNED NOT NULL,
    media_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT NOW(),
    
    FOREIGN KEY (trip_id) REFERENCES trips(id),
    FOREIGN KEY (media_id) REFERENCES media(id)
);


