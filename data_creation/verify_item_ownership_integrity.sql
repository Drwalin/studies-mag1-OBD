
CREATE OR REPLACE PROCEDURE VerifyItemOwnershipIntegrity(
		itemId IN INT) IS
	CURSOR all_transfers IS
		SELECT te.id AS entryId, t.id AS transId, 
			CASE
				WHEN te.from_a = 1 THEN t.owner_a
				ELSE t.owner_b
			END AS entityFrom,
			CASE
				WHEN te.from_a = 1 THEN t.owner_b
				ELSE t.owner_a
			END AS entityTo
	   	FROM transaction_entries te
			JOIN transactions t ON te.transaction = t.id
		WHERE te.item = itemId
		ORDER BY t.stamp ASC;
	transactionId INT;
	transEntryId INT;
	giver VARCHAR2(64);
	taker VARCHAR2(64);
	previousOwner VARCHAR2(64);
BEGIN
	OPEN all_transfers;
	previousOwner := NULL;
	LOOP
		FETCH all_transfers INTO transEntryId, transactionId, giver, taker;
		EXIT WHEN all_transfers%NOTFOUND;
		IF giver <> previousOwner THEN
			dbms_output.put_line('previous owner: ' || previousOwner ||
				';  giver: ' || giver ||
				';  taker: ' || taker ||
				';  transactionId: ' || transactionId ||
				';  transEntryId: ' || transEntryId);
		END IF;
		previousOwner := taker;
	END LOOP;
	CLOSE all_transfers;
END;


SELECT * FROM SYS.USER_ERRORS;


CREATE OR REPLACE PROCEDURE VerifyItemsOwnershipIntegrity IS
	itemId INT;
	CURSOR all_items IS
		SELECT id FROM items;
BEGIN
	OPEN all_items;
	LOOP
		FETCH all_items INTO itemId;
		EXIT WHEN all_items%NOTFOUND;
		VerifyItemOwnershipIntegrity(itemId);
	END LOOP;
	CLOSE all_items;
END;

SELECT * FROM SYS.USER_ERRORS;


BEGIN
	VerifyItemsOwnershipIntegrity();
END;

SELECT * FROM TRANSACTIONS t WHERE t.id = 4487;
SELECT * FROM TRANSACTION_ENTRIES t WHERE t.transaction = 4487;

