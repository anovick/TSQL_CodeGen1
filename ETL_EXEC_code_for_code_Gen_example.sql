use CodeGen_demo_1
go

/*delete from ETL_destination*/

select * from dbo.ETL_destination
select * from attribute

select * from dbo.ETL_source_A
exec dbo.ETL_proc_by_hand_source_A @batch_id = 1 
select * from dbo.ETL_destination

--------------   Here's where the stored procedure is generatefd --------------------

select * from dbo.ETL_source_B


select * from dbo.ETL_destination where attribute_id = dbo.ETL_lookup_attribute_id('preasure')

exec dbo.ETL_proc_Gen_source_B @batch_id=2 
select * from ETL_destination  where attribute_id = dbo.ETL_lookup_attribute_id('preasure')

select attribute_id, count(*) from ETL_destination group by attribute_id order by attribute_id



