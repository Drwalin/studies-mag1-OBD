CREATE OR REPLACE FUNCTION SelectItemOwnerInTimepointOptimised(
		itemId IN INT,
		timepoint IN TIMESTAMP
		) RETURN VARCHAR2 SQL_MACRO AS
BEGIN
	RETURN q'{
	SELECT owner, null, transaction, item, stamp FROM entity_item_receivings
		WHERE stamp <= timepoint
		AND abandonmentTIme > timePoint
		AND item = itemId
	}';
END;

SELECT * FROM SelectItemOwnerInTimepointOptimised(37,
	TO_TIMESTAMP('2000-01-15 15:14:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6'));

SELECT * FROM SelectItemOwnerInTimepoint(37,
	TO_TIMESTAMP('2000-01-15 15:14:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6'));
