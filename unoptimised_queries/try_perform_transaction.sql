CREATE OR REPLACE FUNCTION TryPerformTransaction(
		itemsFromA IN t_ints,
		itemsFromB IN t_ints,
		nameA IN VARCHAR2,
		nameB IN VARCHAR2
-- ) RETURN VARCHAR2 SQL_MACRO AS
) RETURN INT AS -- returns 0 on fault 1 on success
	timepoint TIMESTAMP;
	id INT;
	nam VARCHAR2(128);
	transid INT;
	cnt INT;
BEGIN
	SELECT SYSTIMESTAMP INTO timepoint FROM DUAL;
	
	INSERT INTO transactions (stamp, owner_a, owner_b) VALUES (
			timepoint,
			nameA,
			nameB
		) RETURNING id INTO transid;
	
	
	SELECT itemsFromA.COUNT INTO cnt FROM DUAL;
	FOR i IN itemsFromA LOOP
		id := i;--itemsFromA(i);
		SELECT * INTO nam FROM GetCurrentOwnerOfItem(id);
		IF nam <> nameA THEN
			ROLLBACK;
			RETURN 0;
		END IF;
		INSERT INTO transaction_entries (transaction, from_a, item) VALUES (
			transactionId,
			1,
			id
		);
	END LOOP;
	
	SELECT count(*) INTO cnt FROM itemsFromB;
	FOR i IN 1..cnt LOOP
		id := itemsFromB(i);
		SELECT * INTO nam FROM GetCurrentOwnerOfItem(id);
		IF nam <> nameB THEN
			ROLLBACK;
			RETURN 0;
		END IF;
		INSERT INTO transaction_entries (transaction, from_a, item) VALUES (
			transactionId,
			0,
			id
		);
	END LOOP;
	COMMIT;
	RETURN 1;
END;

SELECT * FROM SYS.USER_ERRORS;

