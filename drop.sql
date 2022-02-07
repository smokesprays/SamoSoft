begin tran

declare @today smalldatetime = getdate()

delete from hotelpr
where @today > dateend  or  @today > rqdateend

select * from hotelpr

rollback