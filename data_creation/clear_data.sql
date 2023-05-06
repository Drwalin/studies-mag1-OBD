
CREATE OR REPLACE PROCEDURE ClearAllData() IS
BEGIN
	DELETE FROM entities;
	DELETE FROM items;
	DELETE FROM transactions;
	DELETE FROM transaction_entries;
	DELETE FROM locations;
	DELETE FROM entities_entered_location;
END;
/

