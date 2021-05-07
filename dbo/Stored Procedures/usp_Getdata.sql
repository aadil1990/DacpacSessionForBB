CREATE PROCEDURE usp_Getdata
(
@tablename VARCHAR(100)
)
AS
BEGIN
DECLARE @query NVARCHAR(1000)
SET @query = 'SELECT * FROM '+ @tablename
EXECUTE (@query)
END
