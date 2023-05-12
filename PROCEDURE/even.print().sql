DELIMITER //
CREATE PROCEDURE even_print(fromVal int,toVal int)
BEGIN
    DROP TEMPORARY TABLE IF EXISTS temp_table_for_even;
	CREATE TEMPORARY TABLE temp_table_for_even (
		even int
	);
    set @iter := 2;
     WHILE @iter <= toVal DO
		IF (@iter % 2) = 0 THEN
			INSERT INTO temp_table_for_even (even) VALUES (@iter);
        END IF;
        SET @iter:=@iter+1;
	 END WHILE;
	
     SELECT even FROM temp_table_for_even;
END
      //
      
CALL even_print(1,10);
