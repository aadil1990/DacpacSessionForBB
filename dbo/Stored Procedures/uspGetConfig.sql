CREATE PROCEDURE [dbo].[uspGetConfig]
AS
BEGIN
	SELECT c.Name,  c.Enabled FROM Config c
	ORDER BY c.Id 
END