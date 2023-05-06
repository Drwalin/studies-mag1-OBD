
CREATE OR REPLACE FUNCTION SelectRandomItemCategory(

CREATE OR REPLACE PROCEDURE CreateRandomItemForRandomEntityWhenAlive() IS
	entityName VARCHAR2(64);
	itemName VARCHAR2(64);
	selectTime TIMESTAMP;
	itemId INTEGER;
BEGIN
	SELECT name INTO entityName FROM entities
		ORDER BY dbms_random.random FETCH FIRST 1 ROWS ONLY;
	SELECT name INTO item_name FROM IMPORTED_ITEM_NAMES
		ORDER BY dbms_random.random FETCH FIRST 1 ROWS ONLY;
	INSERT INTO items (name, weight, description, category, base_price,
		custom_params) VALUES
		(
			name,
			dbms_random.value(0, 100),
			GenerateRandomName(30, 200),
			
		
	
	timestamp_start := CAST(date_start AS TIMESTAMP);
	steps := round(dbms_random.value(steps_min, steps_max));
	
	SELECT name INTO location FROM locations
		ORDER BY dbms_random.random FETCH FIRST 1 ROWS ONLY;
	
	currentTime := AdvanceTimestamp(timestamp_start, hours_min/100, hours_max/10);
	INSERT INTO entities_entered_location (name, location, date_time)
		VALUES (
			entity_name,
			location,
			currentTime
		);
	
	FOR i in 1..steps LOOP
		currentTime := AdvanceTimestamp(currentTime, hours_min, hours_max);
		location := GetAnyLocationExceptCurrent(entity_name, currentTime);
		INSERT INTO entities_entered_location (name, location, date_time)
			VALUES (
				entity_name,
				location,
				currentTime
			);
	END LOOP;
END;

CREATE OR REPLACE PROCEDURE CreateItems(
		countItems IN NUMBER) AS
	itemId INT;
BEGIN
	CreateRandomItemForRandomEntityWhenAlive;
	
END;
	


SELECT * FROM SYS.USER_ERRORS;




