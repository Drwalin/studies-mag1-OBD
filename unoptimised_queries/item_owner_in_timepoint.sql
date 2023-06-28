CREATE OR REPLACE FUNCTION SelectItemOwnerInTimepoint(
		itemId IN INT,
		timepoint IN TIMESTAMP
		) RETURN VARCHAR2 SQL_MACRO AS
BEGIN
	RETURN q'{
	SELECT
			CASE WHEN TE1.from_a = 0 THEN T1.owner_a ELSE T1.owner_b END taker,
			CASE WHEN TE1.from_a = 1 THEN T1.owner_a ELSE T1.owner_b END giver,
			TE1.id, TE1.TRANSACTION, TE1.item, T1.stamp, TE1.from_a, T1.owner_a, T1.owner_b
		FROM transaction_entries TE1, transactions T1
		WHERE TE1.transaction = T1.id
		AND TE1.item = itemId
		AND T1.stamp <= timepoint
		AND (SELECT COUNT(*) FROM transaction_entries TE2, transactions T2
			WHERE TE2.transaction = T2.id
			AND TE2.item = itemId
			AND T2.stamp < timepoint
			AND T2.stamp > T1.stamp
		) = 0}';
END;

SELECT * FROM
	SelectItemsOfPlayerInTimepoint('Jamie',
		TO_TIMESTAMP('2005-02-02 12:12:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6')) A,
	SelectItemOwnerInTimepoint(A.item,
		TO_TIMESTAMP('2005-02-02 12:12:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6'));

SELECT * FROM SYS.USER_ERRORS;

SELECT * FROM items I1, SelectItemOwnerInTimepoint(I1.id,
		TO_TIMESTAMP('2005-02-02 12:12:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6')) own;

SELECT I1.id, SelectItemOwnerInTimepoint(I1.id,
		TO_TIMESTAMP('2005-02-02 12:12:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6')) own
	FROM items I1;

SELECT count(*) FROM items;

SELECT
			CASE WHEN TE1.from_a = 0 THEN T1.owner_a ELSE T1.owner_b END taker,
			CASE WHEN TE1.from_a = 1 THEN T1.owner_a ELSE T1.owner_b END giver,
			TE1.id, TE1.TRANSACTION, TE1.item, T1.stamp, TE1.from_a, T1.owner_a, T1.owner_b
		FROM TRANSACTION_ENTRIES TE1, TRANSACTIONS T1
	WHERE TE1.TRANSACTION = T1.ID
	AND (
		T1.OWNER_A = 'Jamie'
		OR
		T1.OWNER_B = 'Jamie'
	) ORDER BY T1.stamp;

