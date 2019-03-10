/*

Advent of Code - 2018
--- Day 3: No Matter How You Slice It --

Released under the MIT License <http://opensource.org/licenses/mit-license.php>

*/

IF OBJECT_ID('TEMPDB..#CLAIMS') IS NOT NULL
	DROP TABLE #CLAIMS

;WITH INPUT_D03 AS 
(
    SELECT REPLACE(F.[ITEM], CHAR(10), '') AS CLAIM
      FROM OPENROWSET(BULK 'D:\repos\aoc2018-sql\input\d03.txt', SINGLE_CLOB) INPUT_FILE(FILE_DATA)
     CROSS APPLY dbo.udf_string_split(INPUT_FILE.FILE_DATA, CHAR(13)) F
), CLAIMS AS
(
    SELECT INPUT_D03.CLAIM, 
           CLAIMS.CLAIM_ID,
           CONVERT(INT, CLAIMS.X) AS X,
           CONVERT(INT, CLAIMS.Y) AS Y,
           CONVERT(INT, CLAIMS.X_SIZE) AS X_SIZE,
           CONVERT(INT, CLAIMS.Y_SIZE) AS Y_SIZE
      FROM INPUT_D03
     CROSS APPLY	--Helper to identify the relevant parts of the string that represent the claim
       (
         VALUES (CHARINDEX('#', CLAIM),
                 CHARINDEX(' @ ', CLAIM),
                 CHARINDEX(',', CLAIM),
                 CHARINDEX(': ', CLAIM),
                 CHARINDEX('x', CLAIM)
       )) POS(POS_CLAIM_ID, POS_XY_START, POS_X_END, POS_Y_END, POS_SIZE_SPLIT)
     CROSS APPLY
       ( 
         VALUES (SUBSTRING(CLAIM, 1, POS_XY_START), 
                 SUBSTRING(CLAIM, POS_XY_START + 3, POS_X_END-POS_XY_START-3), 
                 SUBSTRING(CLAIM, POS_X_END + 1, POS_Y_END-POS_X_END-1), 
                 SUBSTRING(CLAIM, POS_Y_END + 1, POS_SIZE_SPLIT-POS_Y_END-1), 
                 SUBSTRING(CLAIM, POS_SIZE_SPLIT + 1, LEN(CLAIM)) 
       )) CLAIMS(CLAIM_ID, X, Y, X_SIZE, Y_SIZE)
)
SELECT *
  INTO #CLAIMS
  FROM CLAIMS
 
SELECT COUNT(1) AS PART_1
  FROM 
   (
     SELECT N2.N AS X, N1.N AS Y
       FROM #CLAIMS C
      CROSS JOIN dbo.tbl_numbers N1
      CROSS JOIN dbo.tbl_numbers N2
      WHERE N1.N BETWEEN C.X AND C.X + C.X_SIZE - 1
        AND N2.N BETWEEN C.Y AND C.Y + C.Y_SIZE - 1
      GROUP BY N1.N, N2.N 
     HAVING COUNT(DISTINCT C.CLAIM_ID) > 1
   ) C
  ;





