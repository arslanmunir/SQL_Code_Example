
-- SplitAuthors is a tabular function used to split authors using a comma separator. 


CREATE FUNCTION [dbo].[SplitAuthors] (@AuthorsString NVARCHAR(MAX))
RETURNS TABLE
AS
RETURN
(
    WITH SplitAuthors AS (
	 
        SELECT distinct ltrim(rtrim(value)) AS Author 
        FROM  STRING_SPLIT(@AuthorsString, ',')
		 
    )
   SELECT
        MAX(CASE WHEN RowNum = 1 THEN ltrim(rtrim(Author)) END) AS Author1,
        MAX(CASE WHEN RowNum = 2 THEN ltrim(rtrim(Author)) END) AS Author2,
        MAX(CASE WHEN RowNum = 3 THEN ltrim(rtrim(Author)) END) AS Author3,
        MAX(CASE WHEN RowNum = 4 THEN ltrim(rtrim(Author)) END) AS Author4,
        MAX(CASE WHEN RowNum = 5 THEN ltrim(rtrim(Author)) END) AS Author5
		from (select author, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowNum  

    FROM SplitAuthors) as M
);
GO