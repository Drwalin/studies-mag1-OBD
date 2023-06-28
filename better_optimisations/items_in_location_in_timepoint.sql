CREATE OR REPLACE FUNCTION SelectAllItemsInLocationInTimepointOptimised1(
		location IN VARCHAR2,
		timepoint IN TIMESTAMP
) RETURN VARCHAR2 SQL_MACRO AS
BEGIN
	RETURN q'{
	SELECT I1.item
		FROM SelectAllEntitiesInLocationInTimepointOptimised(location, timepoint) E1
			CROSS JOIN LATERAL
			(SELECT * FROM SelectItemsOfPlayerInTimepointOptimised(E1.name, timepoint)) I1
	}';
END;

CREATE OR REPLACE FUNCTION SelectAllItemsInLocationInTimepointOptimised2(
		loc IN VARCHAR2,
		timepoint IN TIMESTAMP
) RETURN VARCHAR2 SQL_MACRO AS
BEGIN
	RETURN q'{
	SELECT * FROM entity_item_receivings i1, entity_in_location l1
		WHERE l1.location = loc
		AND l1.entered <= timepoint
		AND (
			l1.leaved >= timepoint
			OR l1.leaved IS NULL
		)
		AND i1.owner = l1.name
		AND i1.stamp <= timepoint
		AND (
			i1.abandonmentTIme >= timepoint
			OR i1.abandonmentTIme IS NULL
		)
	}';
END;


SELECT * FROM SYS.USER_ERRORS;


SELECT item FROM SelectAllItemsInLocationInTimepointOptimised2('Alabama',
		TO_TIMESTAMP('2000-01-15 15:14:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6')) ORDER BY item;

SELECT item FROM SelectAllItemsInLocationInTimepointOptimised1('Alabama',
		TO_TIMESTAMP('2000-01-15 15:14:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6')) ORDER BY item;

SELECT item FROM SelectAllItemsInLocationInTimepoint('Alabama',
		TO_TIMESTAMP('2000-01-15 15:14:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6')) ORDER BY item;


