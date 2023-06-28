CREATE OR REPLACE FUNCTION SelectAllEntitiesInLocationInTimepointOptimised(
		loc IN VARCHAR2,
		timepoint IN TIMESTAMP
) RETURN VARCHAR2 SQL_MACRO AS
BEGIN
	RETURN q'{
	SELECT DISTINCT EL1.name
		FROM entity_in_location EL1
		WHERE EL1.location = loc
		AND EL1.entered <= timepoint
		AND (
			EL1.leaved > timepoint
			OR EL1.leaved IS NULL
		)
	}';
END;

SELECT * FROM SYS.USER_ERRORS;

SELECT * FROM SelectAllEntitiesInLocationInTimepointOptimised('Alabama',
		TO_TIMESTAMP('2000-01-15 15:14:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6')) ORDER BY name;

SELECT * FROM SelectAllEntitiesInLocationInTimepoint('Alabama',
		TO_TIMESTAMP('2000-01-15 15:14:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6')) ORDER BY name;
