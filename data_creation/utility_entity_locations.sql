
CREATE OR REPLACE FUNCTION AdvanceTimestamp(
		entityName IN VARCHAR2,
		created OUT TIMESTAMP,
		lastEntry OUT TIMESTAMP) RETURN TIMESTAMP IS
BEGIN
	SELECT date_time INTO created FROM entities_entered_location E1
		WHERE name = entityName AND (
			SELECT count(*) FROM entities_entered_location E2
			WHERE name = entityName AND E1.date_time > E2.date_time
		) = 0;
	SELECT date_time INTO lastEntry FROM entities_entered_location E1
		WHERE name = entityName AND (
			SELECT count(*) FROM entities_entered_location E2
			WHERE name = entityName AND E1.date_time < E2.date_time
		) = 0;
END;


CREATE OR REPLACE TYPE t_strings AS TABLE OF VARCHAR2(1024);

CREATE OR REPLACE FUNCTION SelectAllEntityNamesInLocationDuringTime(
		locationn IN VARCHAR2,
		timepoint IN TIMESTAMP) RETURN t_strings AS
	stmt CLOB;
	ret t_strings;
BEGIN
	SELECT name BULK COLLECT INTO ret FROM entities_entered_location E1
		WHERE E1.location = locationn AND E1.date_time <= timepoint
		AND
		(SELECT count(*) FROM entities_entered_location E2
			WHERE E2.location = locationn
			AND E2.name = E1.name
			AND E2.date_time > E1.date_time
			AND E2.date_time <= timepoint
		) = 0
		GROUP BY E1.name;
	RETURN ret;
END;

SELECT * FROM SYS.USER_ERRORS;

SELECT * FROM ENTITIES_ENTERED_LOCATION ORDER BY location; FETCH FIRST 100 ROWS ONLY;
SELECT * FROM ENTITIES;

SELECT * FROM entities_entered_location t1 WHERE t1.name IN (SELECT * FROM SelectAllEntityNamesInLocationDuringTime('Athens', TO_TIMESTAMP('2000-01-10', 'YYYY-MM-DD'))) ORDER BY t1.LOCATION;
SELECT * FROM SelectAllEntityNamesInLocationDuringTime('Athens', TO_TIMESTAMP('2000-01-10', 'YYYY-MM-DD'));

SELECT * FROM entities_entered_location WHERE location = 'Athens';


