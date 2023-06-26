
CREATE OR REPLACE PROCEDURE MoveEntityInto(
		entity IN VARCHAR2
		loc IN VARCHAR2,
) RETURN VARCHAR2 SQL_MACRO AS
	timepoint TIMESTAMP;
BEGIN
	SELECT SYSTIMESTAMP INTO timepoint FROM DUAL;

	INSERT INTO entities_entered_location (name, locaion, date_time)
	VALUES (entity, loc, timepoint);
END;

