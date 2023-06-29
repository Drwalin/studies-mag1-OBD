CREATE OR REPLACE VIEW basic_entity_item_receivings AS 
	SELECT
		T1.stamp stamp,
		TE1.item item, 
		CASE WHEN TE1.from_a = 0 THEN T1.owner_a ELSE T1.owner_b END owner,
		T1.id transaction
	FROM transaction_entries TE1, transactions T1
	WHERE T1.id = TE1.transaction;

CREATE OR REPLACE VIEW view_for_creating_entity_item_receive AS
	SELECT b1.stamp stamp, b1.item item, b1.owner owner, b1.transaction transaction, b2.stamp abandonmentTIme
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
	
INSERT INTO entity_item_receivings (stamp, item, owner, transaction, abandonmentTIme)
	SELECT stamp, item, owner, transaction, abandonmentTIme
	FROM view_for_creating_entity_item_receive;
	
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







CREATE TABLE entity_in_location (
	name VARCHAR(64) NOT NULL, -- references entities.name
	location VARCHAR(128) NOT NULL, -- references locations.name
	entered TIMESTAMP,
	leaved TIMESTAMP,
	
	CONSTRAINT location_ref3
		FOREIGN KEY (location)
		REFERENCES locations (name),
	CONSTRAINT entity_ref3
		FOREIGN KEY (name)
		REFERENCES entities (name)
);

DELETE entity_in_location;

CREATE OR REPLACE VIEW view_for_creating_entity_in_location AS
	SELECT L1.name name, L1.location location, L1.date_time entered, L2.date_time leaved
	FROM entities_entered_location L1, entities_entered_location L2
	WHERE L1.name = L2.name
	AND L1.date_time < L2.date_time
	AND (
		SELECT count(*)
		FROM entities_entered_location L3
		WHERE L3.name = L1.name
		AND L3.date_time > L1.date_time
		AND L3.date_time < L2.date_time
	) = 0
UNION
	SELECT L1.name, L1.location, L1.date_time, NULL
	FROM entities_entered_location L1
	WHERE (
		SELECT count(*)
		FROM entities_entered_location L3
		WHERE L3.name = L1.name
		AND L3.date_time > L1.date_time
	) = 0;

INSERT INTO entity_in_location (name, location, entered, leaved)
	SELECT name, location, entered, leaved
	FROM view_for_creating_entity_in_location;
