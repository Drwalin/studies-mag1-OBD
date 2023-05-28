
-- select all entities that were in location during given time frame

CREATE OR REPLACE TYPE t_stringa AS TABLE OF VARCHAR2(64);

CREATE OR REPLACE FUNCTION SelectAllEntitiesInLocationDuring(
		loc IN VARCHAR2,
		timeStart IN TIMESTAMP,
		timeEnd IN TIMESTAMP
) RETURN t_strings AS
	ret t_strings;
BEGIN
	SELECT DISTINCT EL1.name BULK COLLECT INTO ret
		FROM entities_entered_location EL1
		WHERE EL1.location = loc
		AND EL1.date_time <= timeEnd
		AND (SELECT count(*) FROM entities_entered_location EL2
			WHERE EL2.location <> loc
			AND EL2.name = EL1.name
			AND EL2.date_time > EL1.date_time
			AND EL2.date_time <= timeStart
		) = 0;
	RETURN ret;
END;

SELECT * FROM SYS.USER_ERRORS;

SELECT COUNT(*) FROM SelectAllEntitiesInLocationDuring('Alabama', TO_TIMESTAMP('2000-01-01 12:12:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6'), TO_TIMESTAMP('2000-01-05 15:14:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6'));

