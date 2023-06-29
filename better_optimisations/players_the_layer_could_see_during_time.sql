CREATE OR REPLACE FUNCTION SelectAllEntitiesTheEntityCanSeeDuringOptimised(
		entityName IN VARCHAR2,
		timeStart IN TIMESTAMP,
		timeEnd IN TIMESTAMP
) RETURN VARCHAR2 SQL_MACRO AS
BEGIN
	RETURN q'{
	SELECT UNIQUE l2.name FROM entity_in_location l1, entity_in_location l2
	WHERE l1.location = l2.location
	AND (
		l1.entered < l2.leaved
		OR l2.leaved IS NULL)
	AND (
		l2.entered < l1.leaved
		OR l1.leaved IS NULL)
	
	AND l1.entered < timeEnd
	AND (
		l1.leaved > timeStart
		OR l1.leaved IS NULL)
	
	AND l2.entered < timeEnd
	AND (
		l2.leaved > timeStart
		OR l2.leaved IS NULL)
	
	AND l1.name = entityName
	}';
END;

SELECT * FROM SYS.USER_ERRORS;

SELECT * FROM ENTITIES e ORDER BY dbms_random.random FETCH FIRST 100 ROWS ONLY;

SELECT * FROM SelectAllEntitiesTheEntityCanSeeDuringOptimised('Santiago',
		TO_TIMESTAMP('2000-01-01 12:12:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6'),
		TO_TIMESTAMP('2000-01-15 15:14:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6')) ORDER BY name;

SELECT * FROM SelectAllEntitiesTheEntityCanSeeDuring('Santiago',
		TO_TIMESTAMP('2000-01-01 12:12:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6'),
		TO_TIMESTAMP('2000-01-15 15:14:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6')) ORDER BY name;


