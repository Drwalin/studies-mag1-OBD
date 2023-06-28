CREATE OR REPLACE VIEW basic_entity_item_receivings AS 
	SELECT
		T1.stamp stamp,
		TE1.item item, 
		CASE WHEN TE1.from_a = 0 THEN T1.owner_a ELSE T1.owner_b END owner,
		T1.id transaction
	FROM transaction_entries TE1, transactions T1
	WHERE T1.id = TE1.transaction;

INSERT INTO entity_item_receivings (stamp, item, owner, transaction, abandonmentTIme)
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
	UNION
		SELECT b1.stamp, b1.item, b1.owner, b1.transaction, NULL
		FROM basic_entity_item_receivings b1
		WHERE (
				SELECT count(*)
				FROM basic_entity_item_receivings b3
				WHERE b3.item = b1.item
				AND b3.stamp > b1.stamp
			) = 0;
	
DELETE entity_item_receivings;


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





