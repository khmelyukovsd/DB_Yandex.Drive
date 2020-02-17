/* Данная база данных предназначена для создания структуры хранения и обработки данных, необходимых
при работе каршеринга Яндекс.Драйв. В базе данных реализованы следующие сущности:
- Пользователи,
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
USE YandexDrive;

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
