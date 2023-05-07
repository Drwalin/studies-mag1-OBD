
CREATE OR REPLACE PROCEDURE ClearAllData IS
BEGIN
	DELETE FROM temp_item_ownership;

	DELETE FROM entities_entered_location;
	DELETE FROM transaction_entries;
	DELETE FROM transactions;
	DELETE FROM entities;
	DELETE FROM items;
	DELETE FROM locations;
END;

SELECT * FROM SYS.USER_ERRORS;

