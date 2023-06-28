CREATE OR REPLACE FUNCTION SelectItemsOfPlayerInTimepointOptimised(
		playerName IN VARCHAR2,
		timepoint IN TIMESTAMP
) RETURN VARCHAR2 SQL_MACRO AS
BEGIN
	RETURN q'{
	SELECT * FROM entity_item_receivings
		WHERE stamp <= timepoint
		AND (
			abandonmentTIme >= timepoint
			OR abandonmentTIme IS NULL
		)
	}';
END;

SELECT * FROM SYS.USER_ERRORS;

SELECT item FROM SelectItemsOfPlayerInTimepointOptimised('Jamie',
	TO_TIMESTAMP('2005-02-02 12:12:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6')) ORDER BY item;

SELECT item FROM SelectItemsOfPlayerInTimepoint('Jamie',
	TO_TIMESTAMP('2005-02-02 12:12:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6')) ORDER BY item;

SELECT id FROM SelectItemsOfPlayerInTimepointUnoptimisedVery('Jamie',
	TO_TIMESTAMP('2005-02-02 12:12:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6')) ORDER BY id;

SELECT id FROM SelectItemsOfPlayerInTimepointUnoptimisedVery2('Jamie',
	TO_TIMESTAMP('2005-02-02 12:12:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6')) ORDER BY id;
