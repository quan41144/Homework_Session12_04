create database Homework_session12_04;
-- create table
create table products(
	product_id serial primary key,
	name varchar(50),
	price numeric,
	stock int
);
create table orders(
	order_id serial primary key,
	product_id int references products(product_id),
	quantity int,
	total_amount numeric
);
-- Viết function cho trigger insert total
create or replace function f_insert_total()
returns trigger as $$
declare
	v_price numeric;
begin
	if tg_op = 'INSERT' then
		select price into v_price from products where product_id = new.product_id;
		if v_price is not null then
			new.total_amount := v_price * new.quantity;
		else
			raise exception 'Sản phẩm không tồn tại!';
		end if;
		return new;
	end if;
end;
$$ language plpgsql;
-- Viết TRIGGER BEFORE INSERT để tự động tính total_amount
create or replace trigger tg_insert_total
before insert on orders
for each row
execute function f_insert_total();
-- insert data
insert into products (name, price, stock) values
('Wireless Mouse', 25.99, 150),
('Mechanical Keyboard', 89.50, 45),
('HD Monitor 24"', 120.00, 30),
('USB-C Hub', 35.00, 200),
('Noise Cancelling Headphones', 199.99, 15),
('Webcam 1080p', 55.00, 60),
('Laptop Stand', 29.95, 85),
('External Hard Drive 1TB', 65.00, 40),
('Gaming Chair', 250.00, 10),
('Desktop Speakers', 45.50, 25);
-- Thêm vài đơn hàng và kiểm tra cột total_amount
INSERT into orders(product_id, quantity, total_amount) values
(2, 45, 0);
select * from orders;