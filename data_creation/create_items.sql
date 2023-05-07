

CREATE OR REPLACE PROCEDURE CreateItemCategories IS
BEGIN
	DELETE FROM item_categories;
	
	INSERT INTO item_categories VALUES ('torso');
	INSERT INTO item_categories VALUES ('hand');
	INSERT INTO item_categories VALUES ('both_hands');
	INSERT INTO item_categories VALUES ('feet');
	INSERT INTO item_categories VALUES ('legs');
	INSERT INTO item_categories VALUES ('head');
	INSERT INTO item_categories VALUES ('consumable');
	INSERT INTO item_categories VALUES ('trinket');
	INSERT INTO item_categories VALUES ('junk');
	INSERT INTO item_categories VALUES ('valuable');
	INSERT INTO item_categories VALUES ('finger');
END;

SELECT * FROM SYS.USER_ERRORS;



CREATE OR REPLACE FUNCTION SelectRandomItemCategory RETURN VARCHAR2 IS
	v VARCHAR2(32);
BEGIN
	SELECT type INTO v FROM item_categories
		ORDER BY dbms_random.random FETCH FIRST 1 ROWS ONLY;
	RETURN v;
END;


CREATE OR REPLACE PROCEDURE CreateRandomItemForRandomEntity(
		timepoint TIMESTAMP) IS
	entityName VARCHAR2(64);
	itemName VARCHAR2(256);
	itemId INT;
	transactionId INT;
BEGIN
	SELECT name INTO entityName FROM entities
		ORDER BY dbms_random.random FETCH FIRST 1 ROWS ONLY;
		
	SELECT item_name INTO itemName FROM IMPORTED_ITEM_NAMES
		ORDER BY dbms_random.random FETCH FIRST 1 ROWS ONLY;
		
	INSERT INTO items (name, weight, description, category, base_price) VALUES (
		itemName,
		RandomGaussian(3, 300),
		GenerateRandomName(30, round(RandomGaussian(25, 200))),
		SelectRandomItemCategory(),
		RandomGaussian(0.1, 300)
	) RETURNING id INTO itemId;
	
	INSERT INTO transactions (stamp, owner_a, owner_b) VALUES (
		timepoint,
		entityName,
		NULL
	) RETURNING id INTO transactionId;
	
	INSERT INTO transaction_entries (transaction, item, from_a) VALUES (
		transactionId,
		itemId,
		0
	);
	
	INSERT INTO temp_item_ownership VALUES (
		itemId,
		entityName
	);
END;


CREATE OR REPLACE PROCEDURE CreateRandomSingleTransaction(
		timepoint TIMESTAMP) IS
	entityA VARCHAR2(64);
	entityB VARCHAR2(64);
	itemId INT;
	transactionId INT;
BEGIN
	SELECT item INTO itemId FROM temp_item_ownership
		ORDER BY dbms_random.random FETCH FIRST 1 ROWS ONLY;
	
	SELECT name INTO entityA FROM temp_item_ownership
		WHERE item = itemId
		ORDER BY dbms_random.random FETCH FIRST 1 ROWS ONLY;
	
	SELECT name INTO entityB FROM entities
		WHERE name <> entityA
		ORDER BY dbms_random.random FETCH FIRST 1 ROWS ONLY;
	
	INSERT INTO transactions (stamp, owner_a, owner_b) VALUES (
			timepoint,
			entityA,
			entityB
		) RETURNING id INTO transactionId;
	
	INSERT INTO transaction_entries (transaction, item, from_a) VALUES (
			transactionId,
			itemId,
			1
		);
	
	UPDATE temp_item_ownership
		SET name = entityB
		WHERE item = itemId;
END;


-- CREATE OR REPLACE PROCEDURE TransferRandomItemBetween(
-- 		transactionId INT,
-- 		from_a CHAR) IS
-- 	fromEntity VARCHAR2(64);
-- 	toEntity VARCHAR2(64);
-- 	itemId INT;
-- BEGIN
-- 	IF from_a = 1 THEN
-- 		SELECT owner_a, owner_b INTO fromEntity, toEntity FROM transactions
-- 		WHERE id = transactionId;
-- 	ELSE
-- 		SELECT owner_b, owner_a INTO fromEntity, toEntity FROM transactions
-- 		WHERE id = transactionId;
-- 	END IF;
-- 	
-- 	SELECT item INTO itemId FROM temp_item_ownership
-- 		WHERE name = fromEntity
-- 		ORDER BY dbms_random.random FETCH FIRST 1 ROWS ONLY;
-- 	
-- 	INSERT INTO transaction_entries (transaction, item, from_a) VALUES (
-- 			transactionId,
-- 			itemId,
-- 			from_a
-- 		);
-- 	
-- 	UPDATE temp_item_ownership
-- 		SET name = toEntity
-- 		WHERE item = itemId;
-- END;

CREATE GLOBAL TEMPORARY TABLE temp_itmes_from_a (
	id INT
) ON COMMIT DELETE ROWS;
CREATE GLOBAL TEMPORARY TABLE temp_itmes_from_b (
	id INT
) ON COMMIT DELETE ROWS;





CREATE OR REPLACE PROCEDURE CreateRandomMultiTransaction(
		timepoint TIMESTAMP) IS
	entityA VARCHAR2(64);
	entityB VARCHAR2(64);
	itemId INT;
	transactionId INT;
	itemsInA INT;
	itemsInB INT;
	itemsCountFromA INT;
	itemsCountFromB INT;
BEGIN
	DELETE FROM temp_itmes_from_a;
	DELETE FROM temp_itmes_from_b;
	
	SELECT name INTO entityA FROM temp_item_ownership
		ORDER BY dbms_random.random FETCH FIRST 1 ROWS ONLY;
	SELECT count(*) INTO itemsInA FROM temp_item_ownership
		WHERE name = entityA;
	itemsCountFromA := round(RandomGaussian(1, itemsInA));

	SELECT name INTO entityB FROM temp_item_ownership
		WHERE name <> entityA
		ORDER BY dbms_random.random FETCH FIRST 1 ROWS ONLY;
	SELECT count(*) INTO itemsInB FROM temp_item_ownership
		WHERE name = entityB;
	itemsCountFromB := round(RandomGaussian(1, itemsInB));
	

	INSERT INTO temp_itmes_from_a SELECT item FROM temp_item_ownership
		WHERE name = entityA
		ORDER BY dbms_random.random FETCH FIRST itemsCountFromA ROWS ONLY;
		
	INSERT INTO temp_itmes_from_b  SELECT item FROM temp_item_ownership
		WHERE name = entityB
		ORDER BY dbms_random.random FETCH FIRST itemsCountFromB ROWS ONLY;
		
		
	INSERT INTO transactions (stamp, owner_a, owner_b) VALUES (
			timepoint,
			entityA,
			entityB
		) RETURNING id INTO transactionId;
		
	
	INSERT INTO transaction_entries (transaction, from_a, item) (
		SELECT
			transactionId,
			1,
			id
		FROM temp_itmes_from_a
	);
	UPDATE temp_item_ownership
		SET name = entityB
		WHERE item IN (SELECT * FROM temp_itmes_from_a);
	
	INSERT INTO transaction_entries (transaction, from_a, item) (
		SELECT
			transactionId,
			0,
			id
		FROM temp_itmes_from_b
	);
	UPDATE temp_item_ownership
		SET name = entityA
		WHERE item IN (SELECT * FROM temp_itmes_from_b);
END;

SELECT * FROM SYS.USER_ERRORS;

CREATE OR REPLACE PROCEDURE CreateItems(
		startTime IN TIMESTAMP,
		iterations IN NUMBER,
		newItemsPerIteration IN NUMBER,
		singleTransactionsPerIteration IN NUMBER,
		multiTransactionsPerIteration IN NUMBER,
		maxHoursBetweenIterations IN NUMBER,
		maxHoursBetweenInternalIterations IN NUMBER) AS
	itemId INT;
	currentTime TIMESTAMP;
BEGIN
	currentTime := startTime;
	FOR i IN 1..iterations LOOP
		currentTime := AdvanceTimestamp(currentTime, 0, maxHoursBetweenIterations);
		FOR j IN 1..RandomGaussian(1, newItemsPerIteration) LOOP
			currentTime := AdvanceTimestamp(currentTime, 0, maxHoursBetweenInternalIterations);
			CreateRandomItemForRandomEntity(currentTime);
		END LOOP;
		FOR j IN 1..RandomGaussian(1, singleTransactionsPerIteration) LOOP
			currentTime := AdvanceTimestamp(currentTime, 0, maxHoursBetweenInternalIterations);
			CreateRandomSingleTransaction(currentTime);
		END LOOP;
		FOR j IN 1..RandomGaussian(1, multiTransactionsPerIteration) LOOP
			currentTime := AdvanceTimestamp(currentTime, 0, maxHoursBetweenInternalIterations);
			CreateRandomMultiTransaction(currentTime);
		END LOOP;
	END LOOP;
END;
	

SELECT * FROM SYS.USER_ERRORS;

