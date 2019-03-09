CREATE FUNCTION [dbo].[udf_string_split]
(
   @string NVARCHAR(MAX),
   @delim  NVARCHAR(255)
)
RETURNS TABLE WITH SCHEMABINDING AS
RETURN
  WITH cteTally(N) AS 
  (
	SELECT TOP (LEN(ISNULL(@string,1))+1) N-1 
	  FROM dbo.tbl_numbers
  ), cteStart(N1) AS 
  (
	SELECT t.N+1 FROM cteTally t
     WHERE (SUBSTRING(@string, t.N, 1) = @delim OR t.N = 0)
  )
  SELECT Item = SUBSTRING(@string, s.N1, ISNULL(NULLIF(CHARINDEX(@delim, @string, s.N1), 0)-s.N1, 8000)),
		 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS ITEM_NUMBER
    FROM cteStart s
GO
