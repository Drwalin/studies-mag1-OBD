

CREATE OR REPLACE FUNCTION WhereWasEntity(
		entity_name IN VARCHAR2,
		currentTime IN TIMESTAMP
		) RETURN VARCHAR2 IS
	locationName VARCHAR2(128);
BEGIN
	SELECT location INTO locationName FROM entities_entered_location L1
		WHERE L1.name = entity_name AND L1.date_time <= currentTime 
		ORDER BY L1.date_time DESC FETCH FIRST 1 ROWS ONLY;
	return locationName;
END;


CREATE OR REPLACE FUNCTION GetAnyLocationExceptCurrent(
		entity_name IN VARCHAR2,
		currentTime TIMESTAMP) RETURN VARCHAR2 IS
	locationName VARCHAR2(128);
BEGIN
	locationName := WhereWasEntity(entity_name, currentTime);
	SELECT name INTO locationName FROM locations WHERE name <> locationName
		ORDER BY dbms_random.random FETCH FIRST 1 ROWS ONLY;
	return locationName;
END;


CREATE OR REPLACE PROCEDURE EnterLocationsForEntity(
		entity_name IN VARCHAR2,
		date_start IN DATE,
		hours_min IN NUMBER,
		hours_max IN NUMBER,
		steps_min IN NUMBER,
		steps_max IN NUMBER) IS
	steps NUMBER;
	currentTime TIMESTAMP;
	location VARCHAR2(128);
BEGIN
	currentTime := date_start;
	steps := round(dbms_random.value(steps_min, steps_max));
	
	SELECT name INTO location FROM locations
		ORDER BY dbms_random.random FETCH FIRST 1 ROWS ONLY;
	
	INSERT INTO entities_entered_location (name, location, date_time)
		VALUES (
			entity_name,
			location,
			currentTime
		);
	
	FOR i in 1..steps LOOP
		currentTime := AdvanceTimestamp(currentTime, hours_min, hours_max);
		SELECT name INTO location FROM locations l WHERE l.name <> location
			ORDER BY dbms_random.random FETCH FIRST 1 ROWS ONLY;
		INSERT INTO entities_entered_location (name, location, date_time)
			VALUES (
				entity_name,
				location,
				currentTime
			);
	END LOOP;
END;


CREATE OR REPLACE PROCEDURE FillEnterLocationsForAll(
		date_start IN DATE,
		hours_min IN NUMBER,
		hours_max IN NUMBER,
		steps_min IN NUMBER,
		steps_max IN NUMBER) IS
	name VARCHAR2(64);
	currentTime TIMESTAMP;
	CURSOR all_entities IS
		SELECT name FROM entities;
BEGIN
	OPEN all_entities;
	
	LOOP
		FETCH all_entities INTO name;
		EXIT WHEN all_entities%NOTFOUND;
		
		EnterLocationsForEntity(name, date_start, hours_min, hours_max,
			steps_min, steps_max);
	END LOOP;
	
	CLOSE all_entities;
END;

SELECT * FROM SYS.USER_ERRORS;




