create FUNCTION [dbo].[Seconds_to_Minutes]
(
	@totalSeconds DECIMAL(18, 2)
)
RETURNS time
AS
BEGIN
	declare @result time
SELECT @result =
    CONVERT(VARCHAR(20), FLOOR(@totalSeconds / 3600)) + ':' +
    RIGHT('0' + CONVERT(VARCHAR(2), FLOOR((@totalSeconds / 60) % 60)), 2) + ':' +
    RIGHT('0' + CONVERT(VARCHAR(2), FLOOR(@totalSeconds % 60)), 2)  
	
	RETURN @result

END