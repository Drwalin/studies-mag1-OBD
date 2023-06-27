
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

BEGIN
	DELETE entity_item_receivings;
	
	INSERT INTO entity_item_receivings (stamp, item, transaction, owner)
		SELECT
			T1.stamp,
			TE1.item, 
			T1.id,
			CASE WHEN TE1.from_a = 0 THEN T1.owner_a ELSE T1.owner_b END,
		FROM transaction_entries TE1, transactions T1
		WHERE T1.id = TE1.transaction;
		
		
	
	INSERT INTO entity_item_receivings (stamp, item, transaction, owner)
		SELECT
			T1.stamp,
			TE1.item, 
			T1.id,
			CASE WHEN TE1.from_a = 0 THEN T1.owner_a ELSE T1.owner_b END,
			CASE WHEN 
				(SELECT COUNT(*) FROM transaction_entries TE3, transactions T3
					WHERE TE3.transaction = T3.id
					AND TE3.item = TE1.item
					AND T3.stamp < T2.stamp
					AND T3.stamp > T1.stamp
				) = 0 THEN T2.stamp ELSE NULL END
		FROM transaction_entries TE1, transactions T1
		LEFT OUTER JOIN transaction_entries TE2
			ON TE2.item = TE1.item
		LEFT OUTER JOIN transactions T2
			ON T2.id = TE2.transaction
		WHERE T1.id = TE1.transaction;
END;

SELECT count(*) FROM entity_item_receivings;

SELECT * FROM SYS.USER_ERRORS;





