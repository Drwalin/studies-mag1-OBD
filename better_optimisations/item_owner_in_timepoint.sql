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
		) = 0}';
END;
