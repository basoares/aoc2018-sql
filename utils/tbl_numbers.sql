SET NOCOUNT ON;
     
DECLARE @MaxNumber INT = 1000000;
     
WITH n AS
(
    SELECT x = ROW_NUMBER() OVER (ORDER BY s1.[object_id])
      FROM sys.all_objects AS s1
     CROSS JOIN sys.all_objects AS s2
     CROSS JOIN sys.all_objects AS s3
)
SELECT N = x
  INTO dbo.tbl_numbers
 FROM n
WHERE x BETWEEN 1 AND @MaxNumber;
     
GO
CREATE UNIQUE CLUSTERED INDEX tbl_numbers_n ON dbo.tbl_numbers(N) 
    WITH (DATA_COMPRESSION = PAGE);
GO
