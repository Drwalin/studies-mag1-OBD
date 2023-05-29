CREATE OR REPLACE FUNCTION SelectAllEntitiesInLocationInTimepoint(
		loc IN VARCHAR2,
		timepoint IN TIMESTAMP
) RETURN VARCHAR2 SQL_MACRO AS
BEGIN
	RETURN q'{
	SELECT DISTINCT EL1.name
		FROM entities_entered_location EL1
		WHERE EL1.location = loc
		AND EL1.date_time <= timepoint
		AND (SELECT COUNT(*) FROM entities_entered_location EL2
			WHERE EL2.location <> loc
			AND EL2.name = EL1.name
			AND EL2.date_time > EL1.date_time
			AND EL2.date_time <= timepoint
		) = 0
	}';
END;

SELECT * FROM SYS.USER_ERRORS;

SELECT COUNT(*) FROM SelectAllEntitiesInLocationInTimepoint('Alabama',
		TO_TIMESTAMP('2000-01-15 15:14:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6'));


