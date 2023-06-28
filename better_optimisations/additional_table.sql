CREATE OR REPLACE VIEW basic_entity_item_receivings AS 
	SELECT
		T1.stamp stamp,
		TE1.item item, 
		CASE WHEN TE1.from_a = 0 THEN T1.owner_a ELSE T1.owner_b END owner,
		T1.id transaction
	FROM transaction_entries TE1, transactions T1
	WHERE T1.id = TE1.transaction;

INSERT INTO entity_item_receivings (stamp, item, owner, transaction, abandonmentTIme)
SELECT * FROM (
	SELECT * FROM (
		SELECT b1.stamp, b1.item, b1.owner, b1.transaction, b2.stamp
		FROM basic_entity_item_receivings b1, basic_entity_item_receivings b2
		WHERE b1.item = b2.item
		AND b1.stamp < b2.stamp
		AND (
				SELECT count(*)
				FROM basic_entity_item_receivings b3
				WHERE b3.item = b1.item
				AND b3.stamp < b2.stamp
				AND b3.stamp > b1.stamp
			) = 0
		)
	UNION
	SELECT * FROM (
		SELECT b1.stamp, b1.item, b1.owner, b1.transaction, NULL
		FROM basic_entity_item_receivings b1
		WHERE (
				SELECT count(*)
				FROM basic_entity_item_receivings b3
				WHERE b3.item = b1.item
				AND b3.stamp > b1.stamp
			) = 0
		)
	);
	
DELETE entity_item_receivings;

-- DECLARE
-- 	CURSOR en IS
-- 		SELECT e1.stamp, e1.item, e1.owner, e2.stamp
-- 		FROM entity_item_receivings e1, entity_item_receivings e2
-- 		WHERE e1.item = e2.item
-- 		AND e2.stamp > e1.stamp
-- 		AND (SELECT COUNT(*)
-- 			FROM entity_item_receivings e3
-- 			WHERE e1.stamp < e3.stamp
-- 			AND e2.stamp > e3.stamp
-- 		) = 0;
-- 	stamp TIMESTAMP;
-- 	item INT;
-- 	owner VARCHAR(64);
-- 	stamp2 TIMESTAMP;
-- BEGIN
-- 	DELETE entity_item_receivings;
-- 	
-- 	INSERT INTO entity_item_receivings (stamp, item, owner, transaction)
-- 		SELECT
-- 			T1.stamp,
-- 			TE1.item, 
-- 			CASE WHEN TE1.from_a = 0 THEN T1.owner_a ELSE T1.owner_b END,
-- 			T1.id
-- 		FROM transaction_entries TE1, transactions T1
-- 		WHERE T1.id = TE1.transaction;
-- 	
-- 	OPEN en;
-- 	LOOP
-- 		FETCH en INTO stamp, item, owner, stamp2;
-- 		EXIT WHEN en%NOTFOUND;
-- 
-- 		UPDATE entity_item_receivings e1
-- 			SET abandonmentTIme=stamp2
-- 			WHERE e1.stamp = stamp
-- 			AND e1.owner = owner
-- 			AND e1.item = item;
-- 	END LOOP;
-- 	CLOSE en;
-- END;


DROP TABLE entity_item_receivings;

CREATE TABLE entity_item_receivings (
	stamp TIMESTAMP NOT NULL,
	item INT NOT NULL, -- references items.id
	transaction INT NOT NULL, -- references transactions.id
	owner VARCHAR(64), --- references entities.name
	abandonmentTIme TIMESTAMP,
	
	CONSTRAINT owner_ref2
		FOREIGN KEY (owner)
		REFERENCES entities (name),
	
	CONSTRAINT transaction_ref2
		FOREIGN KEY (transaction)
		REFERENCES transactions (id),
	CONSTRAINT item_ref2
		FOREIGN KEY (item)
		REFERENCES items (id),
		
	CONSTRAINT primary_key
		PRIMARY KEY (stamp, item, owner)
);


SELECT count(*) FROM entity_item_receivings;
SELECT count(*) FROM entity_item_receivings WHERE abandonmentTIme = NULL;
SELECT * FROM entity_item_receivings;

SELECT * FROM SYS.USER_ERRORS;





