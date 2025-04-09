use CodeGen_demo_1
go
set quoted_identifier, ansi_nulls on
go

CREATE OR ALTER PROC [dbo].[ETL_proc_Gen_source_B] @batch_id INT
AS
SET NOCOUNT ON

-- Declare variables
DECLARE @max_cnt INT, 
        @cnt INT, 
        @attribute NVARCHAR(50), 
        @attribute_id INT

-- Create temporary table for distinct attributes
CREATE TABLE #attributes (
    cnt INT NOT NULL IDENTITY(1,1),
    attribute NVARCHAR(50) NOT NULL PRIMARY KEY CLUSTERED,
    attribute_id INT NOT NULL
)

-- Populate temp table with distinct attributes and their IDs
INSERT INTO #attributes (attribute, attribute_id)
SELECT DISTINCT [attribute], dbo.ETL_lookup_attribute_id([attribute])
FROM dbo.ETL_source_B
WHERE batch_id = @batch_id

-- Get the maximum count for the loop
SELECT @max_cnt = MAX(cnt) FROM #attributes
SET @cnt = 0

-- Loop through each attribute
WHILE @cnt < @max_cnt
BEGIN
    SET @cnt = @cnt + 1
    
    -- Get the current attribute and its ID
    SELECT @attribute = attribute, 
           @attribute_id = attribute_id
    FROM #attributes
    WHERE cnt = @cnt

    -- Insert rows into ETL_destination, filtering by attribute
    INSERT INTO dbo.ETL_destination (attribute_id, event_dt, event_value)
    SELECT @attribute_id, 
           [when], 
           TRY_CONVERT(FLOAT, [input_value])
    FROM dbo.ETL_source_B
    WHERE TRY_CONVERT(FLOAT, [input_value]) IS NOT NULL
      AND batch_id = @batch_id
      AND [attribute] = @attribute
END
GO