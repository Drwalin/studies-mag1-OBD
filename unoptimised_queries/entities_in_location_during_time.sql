CREATE OR REPLACE FUNCTION SelectAllEntitiesInLocationDuring(
		loc IN VARCHAR2,
		timeStart IN TIMESTAMP,
		timeEnd IN TIMESTAMP
) RETURN VARCHAR2 SQL_MACRO AS
BEGIN
	RETURN q'{
	SELECT DISTINCT EL1.name
		FROM entities_entered_location EL1
		WHERE EL1.location = loc
		AND EL1.date_time <= timeEnd
		AND (SELECT COUNT(*) FROM entities_entered_location EL2
			WHERE EL2.location <> loc
			AND EL2.name = EL1.name
			AND EL2.date_time > EL1.date_time
			AND EL2.date_time <= timeStart
		) = 0
	}';
END;

SELECT * FROM SYS.USER_ERRORS;

SELECT COUNT(*) FROM SelectAllEntitiesInLocationDuring('Alabama',
		TO_TIMESTAMP('2000-01-01 12:12:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6'),
		TO_TIMESTAMP('2000-01-15 15:14:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6'));

CREATE OR REPLACE FUNCTION SelectAllEntitiesInLocationDuringUnoptimised(
		loc IN VARCHAR2,
		timeStart IN TIMESTAMP,
		timeEnd IN TIMESTAMP
) RETURN VARCHAR2 SQL_MACRO AS
BEGIN
	RETURN q'{
	SELECT DISTINCT name FROM (
		SELECT name FROM
			(SELECT DISTINCT E1.name
				FROM entities_entered_location EL1,
					SelectAllEntitiesInLocationInTimepoint(loc, EL1.date_time) E1
				WHERE EL1.date_time <= timeEnd
				AND EL1.date_time >= timeStart)
			UNION ALL (SELECT name FROM
				SelectAllEntitiesInLocationInTimepoint(loc, timeStart))
			UNION ALL (SELECT name FROM
				SelectAllEntitiesInLocationInTimepoint(loc, timeEnd))
		)
	}';
END;

SELECT * FROM SYS.USER_ERRORS;

SELECT * FROM SelectAllEntitiesInLocationDuring('Alabama',
		TO_TIMESTAMP('2000-01-01 12:12:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6'),
		TO_TIMESTAMP('2000-01-15 15:14:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6')) ORDER BY name;

SELECT * FROM SelectAllEntitiesInLocationDuringUnoptimised('Alabama',
		TO_TIMESTAMP('2000-01-01 12:12:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6'),
		TO_TIMESTAMP('2000-01-15 15:14:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6')) ORDER BY name;

