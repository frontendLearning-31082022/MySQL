DELIMITER //
CREATE FUNCTION secs_toString(seconds BIGINT)
   RETURNS VARCHAR(80)
   DETERMINISTIC
   BEGIN
	SET @days=FLOOR(seconds/60/60/24);
    SET @hours=FLOOR( (seconds-(@days*60*60*24) )/60/60);
    SET @mins=FLOOR((   seconds-(@days*60*60*24)-(@hours*60*60)  )/60);
	SET @secs=seconds-(@days*60*60*24)-(@hours*60*60)-(@mins*60);
    
    SET @strinng=CONCAT(@days,' days ', @hours,' hours ',@mins,' minutes ',@secs,' seconds');
   RETURN @strinng;
   END //
DELIMITER ;

SELECT secs_toString(123456);
