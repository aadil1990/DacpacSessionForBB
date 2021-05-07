CREATE PROCEDURE [dbo].[uspGetConfig1]
AS
BEGIN
	SELECT c.Name FROM Config c
	WHERE C.Enabled=1
	ORDER BY c.Id 
END