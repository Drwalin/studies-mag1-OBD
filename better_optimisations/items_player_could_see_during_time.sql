CREATE OR REPLACE FUNCTION SelectAllItemsTheEntityCanSeeDuringOptimised(
		entityName IN VARCHAR2,
		timeStart IN TIMESTAMP,
		timeEnd IN TIMESTAMP
) RETURN VARCHAR2 SQL_MACRO AS
BEGIN
	RETURN q'{
	SELECT UNIQUE item
	FROM (
		SELECT item
		FROM entity_in_location l1,
			entity_in_location l2,
			entity_item_receivings i1
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
		
		
		AND i1.owner = l2.name
		
		AND (
			l1.entered < i1.abandonmentTIme
			OR i1.abandonmentTIme IS NULL)
		AND (
			i1.stamp < l1.leaved
			OR l1.leaved IS NULL)
		
		AND (
			l2.entered < i1.abandonmentTIme
			OR i1.abandonmentTIme IS NULL)
		AND (
			i1.stamp < l2.leaved
			OR l2.leaved IS NULL)
		
		AND i1.stamp < timeEnd
		AND (
			i1.abandonmentTIme > timeStart
			OR i1.abandonmentTIme IS NULL)
	) UNION (
		SELECT item FROM entity_item_receivings i1
		WHERE i1.owner = entityName
		AND i1.stamp < timeEnd
		AND (
			i1.abandonmentTIme > timeStart
			OR i1.abandonmentTIme IS NULL)
	)
	}';
END;

SELECT * FROM SYS.USER_ERRORS;

SELECT * FROM SelectAllItemsTheEntityCanSeeDuringOptimised('Santiago',
		TO_TIMESTAMP('2000-01-01 12:12:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6'),
		TO_TIMESTAMP('2000-01-15 15:14:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6')) ORDER BY item;

SELECT * FROM SelectAllItemsTheEntityCanSeeDuring('Santiago',
		TO_TIMESTAMP('2000-01-01 12:12:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6'),
		TO_TIMESTAMP('2000-01-15 15:14:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6')) ORDER BY item;


