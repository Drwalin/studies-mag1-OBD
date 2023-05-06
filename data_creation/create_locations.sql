
CREATE OR REPLACE PROCEDURE CreateLocations IS
BEGIN
	INSERT INTO locations
		SELECT location_name, 100, round(dbms_random.value(0, 120)), to_date('1900-01-01', 'yyyy-mm-dd')
		FROM imported_location_names GROUP BY location_name;
END;

SELECT * FROM SYS.USER_ERRORS;

