/*

Advent of Code - 2018
--- Day 2: Inventory Management System ---

Released under the MIT License <http://opensource.org/licenses/mit-license.php>

*/


;WITH INPUT_D02 AS 
(
	SELECT REPLACE(REPLACE(F.[ITEM], CHAR(10), ''), CHAR(13), '') AS BOX_ID 
	  FROM OPENROWSET(BULK 'D:\repos\aoc2018-sql\input\d02.txt', SINGLE_CLOB) D01(FREQUENCY)
	 CROSS APPLY dbo.udf_string_split(D01.FREQUENCY, CHAR(13)) F
), COUNTS3 AS
(
	SELECT BOX_ID, C
      FROM INPUT_D02
     CROSS APPLY dbo.udf_string_to_characters(BOX_ID) 
     GROUP BY BOX_ID, C
    HAVING COUNT(1) = 3
), COUNTS2 AS
(
	SELECT BOX_ID, C
      FROM INPUT_D02
     CROSS APPLY dbo.udf_string_to_characters(BOX_ID) 
     GROUP BY BOX_ID, C
    HAVING COUNT(1) = 2
)
SELECT COUNT(DISTINCT C3.BOX_ID) * COUNT(DISTINCT C2.BOX_ID) AS PART_1
  FROM COUNTS3 C3
 CROSS JOIN COUNTS2 C2


;WITH INPUT_D02 AS 
(
	SELECT REPLACE(REPLACE(F.[ITEM], CHAR(10), ''), CHAR(13), '') AS BOX_ID 
	  FROM OPENROWSET(BULK 'D:\repos\aoc2018-sql\input\d02.txt', SINGLE_CLOB) D01(FREQUENCY)
	 CROSS APPLY dbo.udf_string_split(D01.FREQUENCY, CHAR(13)) F
), CTE AS
(
	SELECT BOX_ID, A.B
	  FROM INPUT_D02
	 CROSS JOIN dbo.tbl_numbers N
	 CROSS APPLY (VALUES(COALESCE(LEFT(BOX_ID, N-1), '') + COALESCE(RIGHT(BOX_ID, 26-N), ''))) A(B) 
	WHERE N.N <= 26
)
SELECT B PART_2 
  FROM CTE
 GROUP BY B
 HAVING COUNT(DISTINCT BOX_ID) = 2
