--1.Найдите номер модели, скорость и размер жесткого диска для всех ПК стоимостью менее 500 дол. Вывести: model, speed и hd
SELECT model, speed, hd FROM PC WHERE price<500

--2.Найдите производителей принтеров. Вывести: maker
SELECT DISTINCT maker FROM Product WHERE type='Printer'

--3.Найдите номер модели, объем памяти и размеры экранов ПК-блокнотов, цена которых превышает 1000 дол.
SELECT model, ram, screen FROM Laptop WHERE price>1000

--4.Найдите все записи таблицы Printer для цветных принтеров.
SELECT*FROM Printer WHERE color='y'

--5.Найдите номер модели, скорость и размер жесткого диска ПК, имеющих 12x или 24x CD и цену менее 600 дол.
SELECT model, speed, hd FROM PC WHERE cd IN('12x','24x') 
and price<600

--6.Для каждого производителя, выпускающего ПК-блокноты c объёмом жесткого диска не менее 10 Гбайт, найти скорости таких ПК-блокнотов. Вывод: производитель, скорость.
Select maker, speed  from Product inner join Laptop on Product.model = Laptop.model

where hd >= 10
GROUP BY maker, speed

--7.Найдите номера моделей и цены всех имеющихся в продаже продуктов (любого типа) производителя B (латинская буква).
SELECT DISTINCT pc.model, price FROM Product JOIN PC ON Product.model=PC.model
WHERE maker = 'B'
    UNION
SELECT DISTINCT laptop.model, price FROM Product JOIN Laptop ON Product.model=Laptop.model
WHERE maker = 'B'
    UNION
SELECT DISTINCT printer.model, price FROM Product JOIN Printer ON Product.model=Printer.model
WHERE maker = 'B'

--8.Найдите производителя, выпускающего ПК, но не ПК-блокноты.
SELECT maker FROM Product 
WHERE type = 'PC' AND maker NOT IN (SELECT maker FROM Product WHERE type='Laptop')
GROUP BY maker


--9.Найдите производителей ПК с процессором не менее 450 Мгц. Вывести: Maker
SELECT DISTINCT maker FROM Product JOIN PC 
    ON Product.model=PC.model
WHERE speed>=450

--10.Найдите модели принтеров, имеющих самую высокую цену. Вывести: model, price
SELECT model, price FROM Printer
WHERE price = (SELECT MAX(price) FROM Printer)

--11.Найдите среднюю скорость ПК.
SELECT AVG(speed) FROM PC

--12.Найдите среднюю скорость ПК-блокнотов, цена которых превышает 1000 дол.
SELECT AVG(speed) FROM Laptop
WHERE price>1000

--13.Найдите среднюю скорость ПК, выпущенных производителем A.
SELECT AVG(speed) FROM PC JOIN Product ON PC.model=Product.model
WHERE maker = 'A'

--14.Найдите класс, имя и страну для кораблей из таблицы Ships, имеющих не менее 10 орудий.
select Ships.class, name, country From Ships JOIN Classes
     ON Ships.class=Classes.class
WHERE numGuns >= 10

--15.Найдите размеры жестких дисков, совпадающих у двух и более PC. Вывести: HD
SELECT hd FROM PC
GROUP BY hd
HAVING COUNT(hd)>=2

--16.Найдите пары моделей PC, имеющих одинаковые скорость и RAM. В результате каждая пара указывается только один раз, т.е. (i,j), но не (j,i), 
--Порядок вывода: модель с большим номером, модель с меньшим номером, скорость и RAM.
SELECT  DISTINCT pc_1.model, pc_2.model, pc_1.speed, pc_2.ram FROM pc pc_1, pc pc_2
WHERE pc_1.speed=pc_2.speed AND pc_1.ram=pc_2.ram AND pc_1.model>PC_2.model

--17.Найдите модели ПК-блокнотов, скорость которых меньше скорости каждого из ПК. Вывести: type, model, speed
SELECT DISTINCT type, laptop.model, laptop.speed FROM Laptop, product
WHERE type='laptop' AND laptop.speed< ALL (SELECT speed FROM pc)

--18.Найдите производителей самых дешевых цветных принтеров. Вывести: maker, price
SELECT DISTINCT maker, price FROM product 
    JOIN printer ON product.model=printer.model
WHERE color='y' AND price=(SELECT MIN(price) FROM printer
                           WHERE color='y');
						   
--19.Для каждого производителя, имеющего модели в таблице Laptop, найдите средний размер экрана выпускаемых им ПК-блокнотов. Вывести: maker, средний размер экрана.
SELECT maker, AVG(screen) FROM product
    JOIN laptop on product.model=laptop.model
GROUP BY maker;

--20.Найдите производителей, выпускающих по меньшей мере три различных модели ПК. Вывести: Maker, число моделей ПК.
SELECT maker, COUNT(model) AS Count_Model from product
WHERE type = 'pc'
GROUP BY maker
HAVING COUNT(model) > 2;

--21.Найдите максимальную цену ПК, выпускаемых каждым производителем, у которого есть модели в таблице PC. Вывести: maker, максимальная цена.
SELECT maker, MAX(price) FROM product
    JOIN pc ON product.model=pc.model
GROUP BY maker;

--22.Для каждого значения скорости ПК, превышающего 600 МГц, определите среднюю цену ПК с такой же скоростью. Вывести: speed, средняя цена
SELECT speed, AVG(price) FROM pc
GROUP BY speed
HAVING speed > 600;

--23.Найдите производителей, которые производили бы как ПКсо скоростью не менее 750 МГц, так и ПК-блокноты со скоростью не менее 750 МГц.Вывести: Maker  !!!!НЕПОНЯТНО!!!!!
select distinct product.maker
from product, pc
where product.model = pc.model
and product.type = 'PC'
and pc.speed >= 750
and exists(select 'x' from laptop, product p
where p.model = laptop.model
and p.type = 'Laptop'
and p.maker = product.maker
and laptop.speed >= 750)

--24.Перечислите номера моделей любых типов, имеющих самую высокую цену по всей имеющейся в базе данных продукции.
SELECT model FROM
   (SELECT model, price FROM pc
    UNION
    SELECT model, price FROM laptop
    UNION
    SELECT model, price FROM printer) x
WHERE price = (SELECT MAX(price) FROM (
    SELECT model, price FROM pc
    UNION
    SELECT model, price FROM laptop
    UNION
    SELECT model, price FROM printer) y)
	  
--25.Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM и с самым быстрым процессором среди всех ПК, имеющих наименьший объем RAM. Вывести: Maker
SELECT DISTINCT maker FROM pc 
	JOIN product ON pc.model=product.model
WHERE maker IN (
	SELECT DISTINCT maker FROM product
	WHERE type = 'printer')
AND speed = (SELECT MAX(speed) FROM pc WHERE ram = (SELECT MIN(ram) FROM pc))
AND ram = (SELECT MIN(ram) FROM pc)

--26.Найдите среднюю цену ПК и ПК-блокнотов, выпущенных производителем A (латинская буква). Вывести: одна общая средняя цена.
SELECT SUM(prices) / SUM(models) FROM(
	SELECT COUNT(pc.model) models, SUM(price) prices FROM product
		JOIN pc ON product.model=pc.model
	WHERE maker = 'A'
	UNION
	SELECT COUNT(laptop.model), SUM(price) FROM product
		JOIN laptop ON product.model=laptop.model
	WHERE maker = 'A') this_table
	
--27.Найдите средний размер диска ПК каждого из тех производителей, которые выпускают и принтеры. Вывести: maker, средний размер HD.
SELECT maker, AVG(hd) FROM product
   JOIN pc ON product.model=pc.model
WHERE maker IN (
    SELECT maker FROM product
    WHERE type = 'printer')
GROUP BY maker;

--28.Используя таблицу Product, определить количество производителей, выпускающих по одной модели.
SELECT COUNT(maker) qty FROM (
	SELECT maker, COUNT(model) count FROM product
	GROUP BY maker
	HAVING COUNT(model) = 1
) this_table;

--29.В предположении, что приход и расход денег на каждом пункте приема фиксируется не чаще одного раза в день 
--[т.е. первичный ключ (пункт, дата)], написать запрос с выходными данными (пункт, дата, приход, расход). Использовать таблицы Income_o и Outcome_o.
SELECT income_o.point, income_o.[date], inc, out FROM income_o 
	LEFT JOIN outcome_o ON income_o.point=outcome_o.point AND income_o.[date]=outcome_o.[date]
UNION
SELECT outcome_o.point, outcome_o.[date], inc, out FROM income_o 
	RIGHT JOIN outcome_o ON income_o.point=outcome_o.point AND income_o.[date]=outcome_o.[date]

--30.В предположении, что приход и расход денег на каждом пункте приема фиксируется произвольное число раз (первичным ключом в таблицах является столбец code), 
--требуется получить таблицу, в которой каждому пункту за каждую дату выполнения операций будет соответствовать одна строка.
--Вывод: point, date, суммарный расход пункта за день (out), суммарный приход пункта за день (inc). Отсутствующие значения считать неопределенными (NULL)
SELECT point, [date], SUM(outs), SUM(incs) FROM (
	SELECT point, [date], null AS outs, SUM(inc) incs FROM income 
	GROUP BY point, [date]
	UNION
	SELECT point, [date], SUM(out) outs, null AS incs FROM outcome 
	GROUP BY point, [date]
	) this_table
GROUP BY point, [date]

--31.Для классов кораблей, калибр орудий которых не менее 16 дюймов, укажите класс и страну.
SELECT class, country FROM classes
WHERE bore >= 16

--32.Одной из характеристик корабля является половина куба калибра его главных орудий (mw). С точностью до 2 десятичных знаков 
--определите среднее значение mw для кораблей каждой страны, у которой есть корабли в базе данных.


--33.Укажите корабли, потопленные в сражениях в Северной Атлантике (North Atlantic). Вывод: ship.
SELECT ship FROM outcomes
WHERE battle = 'North Atlantic' AND result = 'sunk'

--34.По Вашингтонскому международному договору от начала 1922 г. запрещалось строить линейные корабли водоизмещением более 35 тыс.тонн. 
--Укажите корабли, нарушившие этот договор (учитывать только корабли c известным годом спуска на воду). Вывести названия кораблей.
SELECT name FROM classes, ships
WHERE type='bb' 
  AND displacement > 35000 
  AND launched >= 1922
  AND classes.class=ships.class
  
SELECT name FROM classes JOIN ships ON classes.class=ships.class
WHERE type='bb' 
  AND displacement > 35000 
  AND launched >= 1922

--!!!НЕПОНЯТНО!!!35.В таблице Product найти модели, которые состоят только из цифр или только из латинских букв (A-Z, без учета регистра). Вывод: номер модели, тип модели.
SELECT model, type FROM product
WHERE model NOT LIKE '%[^0-9]%' OR model NOT LIKE '%[^a-zA-Z]%'

--36.Перечислите названия головных кораблей, имеющихся в базе данных (учесть корабли в Outcomes).
SELECT name FROM (
    SELECT name AS name FROM ships
    UNION
    SELECT ship AS name FROM outcomes) t1
JOIN classes ON t1.name=classes.class

--37.Найдите классы, в которые входит только один корабль из базы данных (учесть также корабли в Outcomes).
SELECT class FROM 
(
SELECT classes.class, name FROM classes
    JOIN ships ON classes.class=ships.class
UNION
SELECT class, ship FROM classes
    JOIN outcomes ON class=ship
) t1
GROUP BY class
HAVING COUNT(name) = 1

--38.Найдите страны, имевшие когда-либо классы обычных боевых кораблей ('bb') и имевшие когда-либо классы крейсеров ('bc').
SELECT country FROM classes
WHERE type = 'bb'
INTERSECT
SELECT country FROM classes
WHERE type = 'bc'

--39.Найдите корабли, `сохранившиеся для будущих сражений`; т.е. выведенные из строя в одной битве (damaged), они участвовали в другой, произошедшей позже.
SELECT DISTINCT ship FROM outcomes 
   JOIN battles bat ON outcomes.battle=bat.name
WHERE result = 'damaged' AND ship IN (
   SELECT ship FROM outcomes JOIN battles ON outcomes.battle=battles.name WHERE
   bat.[date] < battles.[date]
)

--40.Найти производителей, которые выпускают более одной модели, при этом все выпускаемые производителем модели являются продуктами одного типа. Вывести: maker, type
SELECT DISTINCT maker, Max(type) FROM product
GROUP BY maker
HAVING count(model)>1 AND COUNT(DISTINCT type)=1
