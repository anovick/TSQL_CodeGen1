USE [CodeGen_demo_1]
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[etf_proc_Gen_source_B]     @batch_id INT
AS
SET NOCOUNT ON
declare @max_cnt int
	,   @cnt int
	,   @attribute_name nvarchar(50)
	,   @attribute_id INT

	CREATE TABLE #attribute_names (cnt int not null identity(1,1)
	        , attribute_name nvarchar(50) NOT NULL PRIMARY KEY CLUSTERED
			, attribute_id INT NOT NULL )

	INSERT INTO #attribute_names (attribute_name, attribute_id)
		SELECT DISTINCT attribute , dbo.eft_lookup_attribute_id (attribute)
		    FROM dbo.etf_source_B where batch_id = @batch_id

	SELECT @max_cnt = max(cnt) from #attribute_names
	SET @cnt = 0;
WHILE @CNT < @max_cnt BEGIN
		SET @cnt += 1

		SELECT @attribute_name = attribute_name
		     , @attribute_id   = attribute_id
			from #attribute_names where cnt = @cnt

		insert into dbo.etf_destination (attribute_id, event_dt, event_value)
		SELECT @attribute_id
		     , CONVERT (DATETIME, [when] )
			 , try_convert(float, [input_value])
			FROM dbo.etf_source_B
			WHERE TRY_CONVERT (float, [input_value]) IS NOT NULL
			  and batch_id = @batch_id

	END
GO