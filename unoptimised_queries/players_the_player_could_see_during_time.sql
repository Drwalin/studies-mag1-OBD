CREATE OR REPLACE VIEW view_entity_in_location AS
	SELECT L1.name name, L1.location location, L1.date_time entered, L2.date_time leaved
	FROM entities_entered_location L1, entities_entered_location L2
	WHERE L1.name = L2.name
	AND L1.date_time < L2.date_time
	AND (
		SELECT count(*)
		FROM entities_entered_location L3
		WHERE L3.name = L1.name
		AND L3.date_time > L1.date_time
		AND L3.date_time < L2.date_time
	) = 0
UNION
	SELECT L1.name, L1.location, L1.date_time, NULL
	FROM entities_entered_location L1
	WHERE (
		SELECT count(*)
		FROM entities_entered_location L3
		WHERE L3.name = L1.name
		AND L3.date_time > L1.date_time
	) = 0;

CREATE OR REPLACE FUNCTION SelectAllEntitiesTheEntityCanSeeDuring(
		entityName IN VARCHAR2,
		timeStart IN TIMESTAMP,
		timeEnd IN TIMESTAMP
) RETURN VARCHAR2 SQL_MACRO AS
BEGIN
	RETURN q'{
	SELECT UNIQUE l2.name FROM view_entity_in_location l1, view_entity_in_location l2
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

SELECT * FROM SelectAllEntitiesTheEntityCanSeeDuring('Santiago',
		TO_TIMESTAMP('2000-01-01 12:12:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6'),
		TO_TIMESTAMP('2000-01-15 15:14:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6'));

SELECT * FROM SelectAllEntitiesTheEntityCanSeeDuring('Forest',
		TO_TIMESTAMP('2000-01-01 12:12:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6'),
		TO_TIMESTAMP('2000-01-15 15:14:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6'));

