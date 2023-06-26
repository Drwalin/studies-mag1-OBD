CREATE OR REPLACE FUNCTION SelectItemsOfPlayerInTimepoint(
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

CREATE OR REPLACE FUNCTION SelectItemsOfPlayerInTimepointUnoptimisedVery2(
		playerName IN VARCHAR2,
		timepoint IN TIMESTAMP
) RETURN VARCHAR2 SQL_MACRO AS
BEGIN
	RETURN q'{
	SELECT IT.id FROM items IT
		CROSS JOIN LATERAL
		(
			SELECT *
			FROM SelectItemOwnerInTimepoint(IT.id, timepoint) 
		) O1
	WHERE
		O1.taker = playerName
	}';
END;

CREATE OR REPLACE FUNCTION SelectItemsOfPlayerInTimepointUnoptimisedVery(
		playerName IN VARCHAR2,
		timepoint IN TIMESTAMP
) RETURN VARCHAR2 SQL_MACRO AS
BEGIN
	RETURN q'{
	SELECT id FROM items IT
	WHERE
		(
			SELECT taker
			FROM SelectItemOwnerInTimepoint(IT.id, timepoint) 
		) = playerName
	}';
END;


SELECT * FROM SYS.USER_ERRORS;

SELECT floor(dbms_random.value(0, 10)) FROM DUAL;

SELECT * FROM entities WHERE ROWNUM = 1;
SELECT * FROM entities WHERE ROWNUM IN (SELECT floor(dbms_random.value(0, (SELECT count(*) FROM entities))) FROM DUAL);

SELECT * FROM entities ORDER BY dbms_random.random FETCH FIRST 1 ROWS ONLY;

SELECT name FROM entities
OFFSET (SELECT floor(dbms_random.value(0, (SELECT count(*) FROM entities)-1)) FROM DUAL) ROWS
FETCH FIRST 1 ROWS ONLY;


SELECT name FROM (SELECT name, ROWNUM rn FROM entities) WHERE rn = (SELECT floor(dbms_random.value(0, (SELECT count(*) FROM entities)-1)) FROM DUAL);

SELECT floor(dbms_random.value(0, (SELECT count(*) FROM entities)-1)) FROM DUAL;
SELECT count(*) FROM entities;


SELECT item FROM SelectItemsOfPlayerInTimepoint('Jamie',
	TO_TIMESTAMP('2005-02-02 12:12:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6')) ORDER BY item;

SELECT id FROM SelectItemsOfPlayerInTimepointUnoptimisedVery('Jamie',
	TO_TIMESTAMP('2005-02-02 12:12:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6')) ORDER BY id;

SELECT id FROM SelectItemsOfPlayerInTimepointUnoptimisedVery2('Jamie',
	TO_TIMESTAMP('2005-02-02 12:12:12.000', 'YYYY-MM-DD HH24:MI:SS.FF6')) ORDER BY id;


CREATE INDEX index1 ON transactions (stamp);
ALTER INDEX index1 REBUILD;
DROP INDEX index1;
