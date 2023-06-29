CREATE OR REPLACE VIEW view_item_ownership_duration AS
	SELECT b1.stamp time1, b1.item item, b1.owner owner, b1.transaction transaction, b2.stamp time2
	FROM basic_entity_item_receivings b1, basic_entity_item_receivings b2
	WHERE b1.item = b2.item
	AND b1.stamp < b2.stamp
	AND (
			SELECT count(*)
			FROM basic_entity_item_receivings b3
			WHERE b3.item = b1.item
			AND b3.stamp < b2.stamp
			AND b3.stamp > b1.stamp
		) = 0
UNION
	SELECT b1.stamp, b1.item, b1.owner, b1.transaction, NULL
	FROM basic_entity_item_receivings b1
	WHERE (
			SELECT count(*)
			FROM basic_entity_item_receivings b3
			WHERE b3.item = b1.item
			AND b3.stamp > b1.stamp
		) = 0;

CREATE OR REPLACE FUNCTION SelectAllItemsTheEntityCanSeeDuring(
		entityName IN VARCHAR2,
		timeStart IN TIMESTAMP,
		timeEnd IN TIMESTAMP
) RETURN VARCHAR2 SQL_MACRO AS
BEGIN
	RETURN q'{
	SELECT UNIQUE item
	FROM (
		SELECT item
		FROM view_entity_in_location l1,
			view_entity_in_location l2,
			view_item_ownership_duration i1
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
			l1.entered < i1.time2
			OR i1.time2 IS NULL)
		AND (
			i1.time1 < l1.leaved
			OR l1.leaved IS NULL)
		
		AND (
			l2.entered < i1.time2
			OR i1.time2 IS NULL)
		AND (
			i1.time1 < l2.leaved
			OR l2.leaved IS NULL)
		
		AND i1.time1 < timeEnd
		AND (
			i1.time2 > timeStart
			OR i1.time2 IS NULL)
	) UNION (
		SELECT item FROM view_item_ownership_duration i1
		WHERE i1.owner = entityName
		AND i1.time1 < timeEnd
		AND (
			i1.time2 > timeStart
			OR i1.time2 IS NULL)
	)
	}';
END;

SELECT * FROM SYS.USER_ERRORS;

SELECT * FROM SelectAllItemsTheEntityCanSeeDuring('Santiago',
		TO_TIMESTAMP('2000-01-01 12:12:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6'),
		TO_TIMESTAMP('2000-01-15 15:14:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6'));

