--Создать таблицу employees
create table employees(
	id serial primary key,
	employee_name varchar(50) not null
);

--Создать таблицу salary
create table salary (
	id serial primary key,
	monthly_salary int not null
);

--Создать таблицу employee_salary
create table employee_salary (
	id serial primary key,
	employee_id int unique not null,
	salary_id int not null
);

--Создать таблицу roles
create table roles (
	id serial primary key,
	role_name int unique not null
);

--Поменять тип столбца role_name с int на varchar(30)
alter table roles alter column role_name type varchar(30);

--Создать таблицу roles_employee
create table roles_employee (
	id serial primary key,
	employee_id int unique not null,
	role_id int not null,
	foreign key (employee_id)
		references employees(id),
	foreign key (role_id)
		references roles(id)
);

--Просмотр таблиц
select * from employees;
select * from salary;
select * from employee_salary;
select * from roles order by id;
select * from roles_employee;

--Наполнить таблицу employee 70 строками
insert into employees (employee_name)
values ('Полина'), ('Данила'), ('София'), ('Анна'), ('Валерия'), ('Владислав'), ('Максим'), ('Мария'), ('Зоя'),
	   ('Филипп'), ('Иван'), ('Семён'), ('Серафим'), ('Олег'), ('Александра'), ('Виктория'), ('Степан'), ('Матвей'),
	   ('Алиса'), ('Мирослава'), ('Дмитрий'), ('Михаил'), ('Елизавета'), ('Мелания'), ('Александр'), ('Анастасия'),
	   ('Камила'), ('Макар'), ('Павел'), ('Ярослав'), ('Ольга'), ('Кира'), ('Любовь'), ('Николай'), ('Артём'),
	   ('Герман'), ('Дарья'), ('Екатерина'), ('Алексей'), ('Варвара'), ('Роман'), ('Ника'), ('Тимур'), ('Сергей'),
	   ('Амира'), ('Пётр'), ('Вероника'), ('Евгений'), ('Ксения'), ('Фёдор'), ('Тимофей'), ('Валерий'), ('Вера'),
	   ('Даниил'), ('Илья'), ('Лев'), ('Адель'), ('Никита'), ('Мирон'), ('Василиса'), ('Марк'), ('Анисия'), ('Нина'),
	   ('Андрей'), ('Ульяна'), ('Татьяна'), ('Савелий'), ('Лука'), ('Эмилия'), ('Арина');

--Наполнить таблицу salary 16 строками
insert into salary (monthly_salary)
values (1000), (1100), (1200), (1300), (1400), (1500), (1600), (1700), (1800), (1900), (2000), (2100), (2200),
	   (2300), (2400), (2500);

--Наполнить таблицу 40 строками: в 10 строк из 40 вставить несуществующие employee_id
insert into employee_salary (employee_id, salary_id)
values (3, 7), (1, 4), (5, 9), (40, 13), (23, 4), (11, 2), (52, 10), (15, 13), (26, 4), (16, 1),
       (33, 7), (65, 5), (36, 1), (53, 8), (48, 5), (64, 3), (42, 2), (62, 14), (18, 4), (45, 1),
       (56, 2), (66, 9), (12, 1), (8, 9), (2, 3), (51, 10), (41, 4), (32, 5), (30, 10), (35, 7),
       (85, 8), (99, 3), (98, 15), (87, 11), (78, 15), (79, 11), (77, 4), (89, 12), (82, 7), (96, 15);
 
--Наполнить таблицу 20 строками      
insert into roles (role_name)
values ('Junior Python developer'), ('Middle Python developer'), ('Senior_Python_developer'), ('Junior Java developer'),
	   ('Middle Java developer'), ('Senior Java developer'), ('Junior JavaScript developer'), ('Middle JavaScript developer'),
	   ('Senior JavaScript developer'), ('Junior Manual QA engineer'), ('Middle Manual QA engineer'), ('Senior Manual QA engineer'),
	   ('Project Manager'), ('Designer'), ('HR'), ('CEO'), ('Sales manager'), ('Junior Automation QA engineer'),
	   ('Middle Automation QA engineer'), ('Senior Automation QA engineer');

--Изменитть данные role_name с id 3     
update roles set role_name='Senior Python developer' where id = 3;

--Наполнить таблицу roles_employee 40 строками
insert into roles_employee (employee_id, role_id)
values (43, 18), (2, 15), (10, 8), (50, 10), (56, 18), (65, 17), (29, 15), (11, 16), (67, 6), (60, 10),
	   (1, 19), (18, 9), (14, 10), (45, 14), (12, 7), (16, 2), (5, 17), (24, 16), (22, 20), (59, 14),
	   (25, 5), (64, 17), (69, 6), (34, 3), (3, 20), (32, 16), (54, 13), (19, 18), (58, 1), (40, 8),
	   (17, 2), (9, 20), (46, 10), (55, 12), (7, 12), (52, 3), (38, 6), (61, 19), (13, 19), (37, 12);
	   
--1. Вывести всех работников чьи зарплаты есть в базе, вместе с зарплатами.
select employee_name, monthly_salary from employees
	join employee_salary on employees.id=employee_salary.employee_id
	join salary on employee_salary.salary_id = salary.id;

--2. Вывести всех работников у которых ЗП меньше 2000.
select employee_name, monthly_salary from employees e
	join employee_salary es on e.id=es.employee_id
	join salary s on es.salary_id=s.id
	where monthly_salary < 2000;

--3. Вывести все зарплатные позиции, но работник по ним не назначен. (ЗП есть, но не понятно кто её получает.)
select monthly_salary, employee_name from salary s
	join employee_salary es on s.id=es.salary_id 
	full join employees e on es.employee_id=e.id
where e.id is null;

--4. Вывести все зарплатные позиции  меньше 2000 но работник по ним не назначен. (ЗП есть, но не понятно кто её получает.)
select monthly_salary from salary s
	join employee_salary es on s.id=es.salary_id 
	full join employees e on es.employee_id=e.id
where e.id is null and monthly_salary <2000;

--5. Найти всех работников кому не начислена ЗП.
select employee_name, e.id from employees e
	full join employee_salary es on e.id=es.employee_id
	full join salary s on es.salary_id=s.id
where s.id is null;

--6. Вывести всех работников с названиями их должности.
select employee_name, role_name from employees e
	join roles_employee re on e.id=re.employee_id
	join roles r on re.role_id=r.id;

--7. Вывести имена и должность только Java разработчиков.
select employee_name, role_name from employees e
	join roles_employee re on e.id=re.employee_id
	join roles r on re.role_id=r.id
where role_name like '%Java dev%'
order by r.id;

--8. Вывести имена и должность только Python разработчиков.
select employee_name, role_name from employees e
	join roles_employee re on e.id=re.employee_id 
	join roles on re.role_id=roles.id 
where role_name like '%Python dev%'
order by roles.id;

--9. Вывести имена и должность всех QA инженеров.
select employee_name, role_name from employees e
	join roles_employee re on e.id=re.employee_id 
	join roles on re.role_id=roles.id 
where role_name like '%QA%'
order by roles.id;

--10. Вывести имена и должность ручных QA инженеров
select employee_name, role_name from employees e
	join roles_employee re on e.id=re.employee_id 
	join roles on re.role_id=roles.id 
where role_name like '%anual QA%'
order by roles.id;

--11. Вывести имена и должность автоматизаторов QA
select employee_name, role_name from employees e 
	join roles_employee re on e.id=re.employee_id 
	join roles on re.role_id=roles.id 
where role_name like '%on QA%'
order by role_id;

--12. Вывести имена и зарплаты Junior специалистов
select employee_name, monthly_salary, role_name from roles r 
	join roles_employee re on r.id=re.role_id 
	join employees e on re.employee_id=e.id 
	join employee_salary es on e.id=es.employee_id 
	join salary s on es.salary_id=s.id 
where role_name like '%unior%'
order by 2;

--13. Вывести имена и зарплаты Middle специалистов
select employee_name, monthly_salary, role_name from roles r 
	join roles_employee re on r.id=re.role_id 
	join employees e on re.employee_id=e.id 
	join employee_salary es on e.id=es.employee_id 
	join salary s on es.salary_id=s.id 
where role_name like '%iddle%'
order by 2;

--14. Вывести имена и зарплаты Senior специалистов
select employee_name, monthly_salary, role_name from roles r 
	join roles_employee re on r.id=re.role_id 
	join employees e on re.employee_id=e.id 
	join employee_salary es on e.id=es.employee_id 
	join salary s on es.salary_id=s.id 
where role_name like '%enior%'
order by 2;

--15. Вывести зарплаты Java разработчиков
select monthly_salary, role_name from roles r 
	join roles_employee re on r.id=re.role_id 
	join employees e on re.employee_id=e.id 
	join employee_salary es on e.id=es.employee_id 
	join salary s on es.salary_id=s.id 
where role_name like '%ava%'
order by 2;

--16. Вывести зарплаты Python разработчиков
select monthly_salary, role_name from roles r 
	join roles_employee re on r.id=re.role_id 
	join employees e on re.employee_id=e.id 
	full join employee_salary es on e.id=es.employee_id 
	full join salary s on es.salary_id=s.id 
where role_name like '%ython%'
order by 1;

--17. Вывести имена и зарплаты Junior Python разработчиков
select employee_name, monthly_salary from salary s
	join employee_salary es on s.id=es.salary_id 
	full join employees e on es.employee_id=e.id 
	join roles_employee re on e.id=re.employee_id 
	join roles r on re.role_id=r.id 
where role_name like '%Junior Python dev%';

--18. Вывести имена и зарплаты Middle JS разработчиков
select employee_name, monthly_salary from salary s
	join employee_salary es on s.id=es.salary_id 
	full join employees e on es.employee_id=e.id 
	join roles_employee re on e.id=re.employee_id 
	join roles r on re.role_id=r.id 
where role_name like '%Middle JavaScript dev%';

--19. Вывести имена и зарплаты Senior Java разработчиков
select employee_name, monthly_salary from salary s
	join employee_salary es on s.id=es.salary_id 
	full join employees e on es.employee_id=e.id 
	join roles_employee re on e.id=re.employee_id 
	join roles r on re.role_id=r.id 
where role_name like '%Senior _ava dev%';

--20. Вывести зарплаты Junior QA инженеров
select monthly_salary, role_name from salary s
	join employee_salary es on s.id=es.salary_id 
	join employees e on es.employee_id=e.id 
	join roles_employee re on e.id=re.employee_id 
	join roles r on re.role_id=r.id
where role_name like '%Junior %QA%';

--21. Вывести среднюю зарплату всех Junior специалистов
select avg(monthly_salary) from salary s
	join employee_salary es on s.id=es.salary_id
	join employees e on es.employee_id=e.id 
	join roles_employee re on e.id=re.employee_id 
	join roles r on re.role_id=r.id
where role_name like '%_unior%';

--22. Вывести сумму зарплат JS разработчиков
select sum(monthly_salary) from salary s
	join employee_salary es on s.id=es.salary_id
	join employees e on es.employee_id=e.id 
	join roles_employee re on e.id=re.employee_id 
	join roles r on re.role_id=r.id
where role_name like '%_avaScript dev%';

--23. Вывести минимальную ЗП QA инженеров
select min(monthly_salary) from salary s
	join employee_salary es on s.id=es.salary_id
	join employees e on es.employee_id=e.id 
	join roles_employee re on e.id=re.employee_id 
	join roles r on re.role_id=r.id
where role_name like '%QA%';

--24. Вывести максимальную ЗП QA инженеров
select max(monthly_salary) from salary s
	join employee_salary es on s.id=es.salary_id
	join employees e on es.employee_id=e.id 
	join roles_employee re on e.id=re.employee_id 
	join roles r on re.role_id=r.id
where role_name like '%QA%';

--25. Вывести количество QA инженеров
select count(role_id) from salary s
	join employee_salary es on s.id=es.salary_id
	join employees e on es.employee_id=e.id 
	join roles_employee re on e.id=re.employee_id 
	join roles r on re.role_id=r.id
where role_name like '%QA%';

--26. Вывести количество Middle специалистов.
select count(role_id) from salary s
	join employee_salary es on s.id=es.salary_id
	join employees e on es.employee_id=e.id 
	join roles_employee re on e.id=re.employee_id 
	join roles r on re.role_id=r.id
where role_name like '%Middle%';

--27. Вывести количество разработчиков
select count(role_id) from salary s
	join employee_salary es on s.id=es.salary_id
	join employees e on es.employee_id=e.id 
	join roles_employee re on e.id=re.employee_id 
	join roles r on re.role_id=r.id
where role_name like '%dev%';

--28. Вывести фонд (сумму) зарплаты разработчиков.
select sum(monthly_salary) from salary s
	join employee_salary es on s.id=es.salary_id
	join employees e on es.employee_id=e.id 
	join roles_employee re on e.id=re.employee_id 
	join roles r on re.role_id=r.id
where role_name like '%dev%';

--29. Вывести имена, должности и ЗП всех специалистов по возрастанию
select employee_name, role_name, monthly_salary from salary s
	join employee_salary es on s.id=es.salary_id 
	join employees e on es.employee_id=e.id 
	join roles_employee re on e.id=re.employee_id
	join roles r on re.role_id=r.id
order by 3;	

--30. Вывести имена, должности и ЗП всех специалистов по возрастанию у специалистов у которых ЗП от 1700 до 2300
select employee_name, role_name, monthly_salary from salary s
	join employee_salary es on s.id=es.salary_id 
	join employees e on es.employee_id=e.id 
	join roles_employee re on e.id=re.employee_id
	join roles r on re.role_id=r.id
where monthly_salary between 1700 and 2300
order by 3;	

--31. Вывести имена, должности и ЗП всех специалистов по возрастанию у специалистов у которых ЗП меньше 2300
select employee_name, role_name, monthly_salary from salary s
	join employee_salary es on s.id=es.salary_id 
	join employees e on es.employee_id=e.id 
	join roles_employee re on e.id=re.employee_id
	join roles r on re.role_id=r.id
where monthly_salary < 2300
order by 3;	

--32. Вывести имена, должности и ЗП всех специалистов по возрастанию у специалистов у которых ЗП равна 1100, 1500, 2000
select employee_name, role_name, monthly_salary from salary s
	join employee_salary es on s.id=es.salary_id 
	join employees e on es.employee_id=e.id 
	join roles_employee re on e.id=re.employee_id
	join roles r on re.role_id=r.id
where monthly_salary in (1100, 1500, 2000)
order by 3;	