CREATE OR REPLACE FUNCTION SelectItemsOfPlayerInTimepointOptimised(
		playerName IN VARCHAR2,
		timepoint IN TIMESTAMP
) RETURN VARCHAR2 SQL_MACRO AS
BEGIN
	RETURN q'{
	SELECT DISTINCT TE1.id, TE1.TRANSACTION, TE1.item,
			CASE WHEN TE1.from_a = 1 THEN T1.owner_a ELSE T1.owner_b END giver,
			CASE WHEN TE1.from_a = 0 THEN T1.owner_a ELSE T1.owner_b END taker,
			T1.stamp, TE1.from_a, T1.owner_a, T1.owner_b
		FROM transaction_entries TE1, transactions T1
		WHERE TE1.transaction = T1.id
		AND T1.stamp <= timepoint
		AND ((
			TE1.from_a = 1
			AND playerName = T1.owner_b
		) OR (
			TE1.from_a = 0
			AND playerName = T1.owner_a
		))
		AND (SELECT COUNT(*) FROM transaction_entries TE2, transactions T2
			WHERE TE2.transaction = T2.id
			AND TE2.item = TE1.item
			AND T2.stamp <= timepoint
			AND T2.stamp > T1.stamp
		) = 0
	}';
END;

