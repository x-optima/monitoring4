# Домашнее задание по лекции "`Домашнее задание к занятию «SQL. Часть 2»`" - `Попов Всеволод`

### Задание 1

Одним запросом получите информацию о магазине, в котором обслуживается более 300 покупателей, и выведите в результат следующую информацию:
- фамилия и имя сотрудника из этого магазина;
- город нахождения магазина;
- количество пользователей, закреплённых в этом магазине.

`SELECT b.name, b.city, COUNT(a.store_id) AS clients`
`FROM sakila.staff_list b LEFT JOIN sakila.customer a `
`ON b.id = a.store_id`
`GROUP BY b.name, b.city`
`HAVING clients > 300;`

![Скриншот-1](https://github.com/MeSeurus/sys-pattern-homework/blob/main/img/screen_12.png)

### Задание 2

Получите количество фильмов, продолжительность которых больше средней продолжительности всех фильмов.

`SELECT COUNT(*) AS result`
`FROM sakila.film`
`WHERE length > (SELECT AVG(length) from sakila.film);`

![Скриншот-2](https://github.com/MeSeurus/sys-pattern-homework/blob/main/img/screen_22.png)

### Задание 3

Получите информацию, за какой месяц была получена наибольшая сумма платежей, и добавьте информацию по количеству аренд за этот месяц.

`SELECT MONTH(payment_date) AS payment_month, SUM(amount) AS total_amount, `
`Count(*) AS rental_count`
`FROM sakila.payment`
`GROUP BY payment_month`
`ORDER BY total_amount DESC`
`LIMIT 1;`

![Скриншот-3](https://github.com/MeSeurus/sys-pattern-homework/blob/main/img/screen_32.png)

UPD:
Исправленный вариант:

`SELECT EXTRACT(YEAR FROM payment_date) AS payment_year, EXTRACT(MONTH FROM payment_date) AS payment_month, SUM(amount) AS total_amount,  Count(*) AS rental_count`
`FROM sakila.payment`
`GROUP BY payment_year, payment_month`
`ORDER BY total_amount DESC`
`LIMIT 1;`

+--------------+---------------+--------------+--------------+
| payment_year | payment_month | total_amount | rental_count |
+--------------+---------------+--------------+--------------+
|         2005 |             7 |     28368.91 |         6709 |
+--------------+---------------+--------------+--------------+

UPD2:
Добавил через DATE_FORMAT

`SELECT DATE_FORMAT(payment_date, ‘%Y-%m’) AS payment_month, SUM(amount) AS total_amount,  Count(*)AS rental_count`
`FROM sakila.payment`
`GROUP BY payment_month`
`ORDER BY total_amount DESC`
`LIMIT 1;`
