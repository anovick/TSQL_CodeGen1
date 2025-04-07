use CodeGen_demo_1
go

/*delete from etf_destination*/

select * from dbo.etf_destination
select * from dbo.etf_source_A
select * from attribute

exec dbo.etf_proc_by_hand_source_A @batch_id = 1 
select * from dbo.etf_destination



select * from dbo.etf_source_B
select * from attribute

select * from dbo.etf_destination where attribute_id = 2

exec dbo.etf_proc_Gen_source_B @batch_id=2 
select * from etf_destination  where attribute_id = 2

select attribute_id, count(*) from etf_destination group by attribute_id order by attribute_id



