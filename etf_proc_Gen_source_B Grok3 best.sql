set quoted_identifier, ansi_nulls on
go

CREATE OR ALTER PROC [dbo].[etf_proc_Gen_source_B] @batch_id INT
AS
SET NOCOUNT ON

DECLARE @max_cnt int,
        @cnt int,
        @attribute_name nvarchar(50),
        @attribute_id INT

-- Create a temporary table to hold distinct attributes and their IDs
CREATE TABLE #attribute_names (
    cnt int NOT NULL IDENTITY(1,1),
    attribute_name nvarchar(50) NOT NULL PRIMARY KEY CLUSTERED,
    attribute_id INT NOT NULL
)

-- Populate the temp table with distinct attributes for the batch
INSERT INTO #attribute_names (attribute_name, attribute_id)
SELECT DISTINCT attribute, dbo.eft_lookup_attribute_id(attribute)
FROM dbo.etf_source_B
WHERE batch_id = @batch_id

-- Get the number of attributes to process
SELECT @max_cnt = MAX(cnt) FROM #attribute_names
SET @cnt = 0

-- Loop through each attribute
WHILE @cnt < @max_cnt
BEGIN
    SET @cnt = @cnt + 1
    
    -- Get the current attribute name and ID
    SELECT @attribute_name = attribute_name,
           @attribute_id = attribute_id
    FROM #attribute_names
    WHERE cnt = @cnt

    -- Insert rows for this attribute where input_value is a valid float
    INSERT INTO dbo.etf_destination (attribute_id, event_dt, event_value)
    SELECT @attribute_id,
           CONVERT(datetime, [when]),
           TRY_CONVERT(float, [input_value])
    FROM dbo.etf_source_B
    WHERE batch_id = @batch_id
      AND attribute = @attribute_name
      AND TRY_CONVERT(float, [input_value]) IS NOT NULL
END

