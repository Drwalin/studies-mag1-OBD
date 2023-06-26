CREATE OR REPLACE FUNCTION GetCurrentOwnerOfItem(
		itemId IN INT
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
		ORDER BY T1.stamp DESC
		FETCH FIRST 1 ROW ONLY
		}';
END;

SELECT * FROM SYS.USER_ERRORS;

SELECT * FROM GetCurrentOwnerOfItem((SELECT item FROM TRANSACTION_ENTRIES te ORDER BY dbms_random.random FETCH FIRST 1 ROW ONLY));

