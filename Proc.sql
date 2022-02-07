USE sqltour_demo;
GO
CREATE PROCEDURE PriceForMonth

    @htplace INT,
    @meal INT
AS

BEGIN

DECLARE @price1 INT = 4000, @price2 INT = 4500, @price3 INT = 3500, @price4 INT = 2000, @price5 INT = 1500; --набор цен

DECLARE @Table TABLE (rom INT, hot int) --таблица номеров и отелей

declare @mesiac int, @date smalldatetime, @count int = 0                        

set @mesiac = 12  -- расчет на год

set @date = dateadd(month,datediff(month,0,GetDate()),0) -- точка отсчета - начало текущего месяца
 
INSERT INTO @Table
select room, hotel
from roomdesc
join hotel on roomdesc.hotel = hotel.inc join room on roomdesc.room = room.inc --заполняем таблицу запросом


while @mesiac != -1  -- счетчик до конца года
begin
insert into hotelpr(hotel, htplace, datebeg, dateend, complete, currency, meal, spotype, spos,  
rspotype, rspos, cure, room, as_checkin, price, usecontract, author) 



select  hot, @htplace, DATEADD(month, @count, @date), eomonth(DATEADD(month, @count, @date)), 1, 1, @meal, 1, -2147483647, -2147483647, -2147483647, 
1, rom, 0, RAND()*(@price1-@price5)+@price5, 1, 1 
from @Table
WHERE   Exists (select * from hotelpr where hotel = hot and room = rom and meal = @meal and htplace = @htplace) 
and not exists(select * from hotelpr where datebeg = DATEADD(month, @count, @date) and dateend = eomonth(DATEADD(month, @count, @date)))

set @mesiac = @mesiac - 1
set @count += 1

end

select * from hotelpr
END

select * from hotelpr
sp_help hotelpr

begin tran
exec PriceForMonth @htplace = 5, @meal = 1
select * from hotelpr
rollback
drop proc PriceForMonth